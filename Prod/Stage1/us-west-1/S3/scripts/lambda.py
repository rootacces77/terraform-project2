import json
import os
import ipaddress
from datetime import datetime
from typing import Any, Dict, List, Tuple, Set

import boto3
from botocore.exceptions import ClientError

# Environment variables (required unless defaults noted)
# - WAF_SCOPE: "REGIONAL" or "CLOUDFRONT"
# - WAF_REGION: region to call WAFv2 in (REQUIRED for CLOUDFRONT = "us-east-1"; for REGIONAL = your WebACL region)
# - WAF_IP_SET_ID: IPSet ID
# - WAF_IP_SET_NAME: IPSet name
# - SNS_TOPIC_ARN: SNS topic ARN to notify admin
#
# Optional:
# - EVENT_DETAIL_KEY: dot-path in message body (default: "detail.offenderIp")
# - BAN_MESSAGE: message text (default: "Banned by automation")
# - LOG_LEVEL: "INFO" or "DEBUG" (default: "INFO")
# - MAX_IPS_PER_UPDATE: safety cap for a single invocation (default: 500)

LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO").upper()

def log(msg: str):
    if LOG_LEVEL in ("INFO", "DEBUG"):
        print(msg)

def debug(msg: str):
    if LOG_LEVEL == "DEBUG":
        print(msg)

def utc_ts() -> str:
    return datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

def get_env(name: str) -> str:
    v = os.environ.get(name)
    if not v:
        raise RuntimeError(f"Missing required environment variable: {name}")
    return v

def extract_dotpath(obj: Dict[str, Any], path: str) -> Any:
    cur: Any = obj
    for part in path.split("."):
        if isinstance(cur, dict) and part in cur:
            cur = cur[part]
        else:
            return None
    return cur

def normalize_ip_to_cidr(ip_str: str) -> str:
    """
    Accepts:
      - "1.2.3.4" -> "1.2.3.4/32"
      - "2001:db8::1" -> "2001:db8::1/128"
      - "1.2.3.0/24" -> unchanged (validated)
    """
    ip_str = ip_str.strip()
    if "/" in ip_str:
        net = ipaddress.ip_network(ip_str, strict=False)
        return str(net)
    addr = ipaddress.ip_address(ip_str)
    if addr.version == 4:
        return f"{addr}/32"
    return f"{addr}/128"

def parse_offender_ips_from_sqs_record(record_body: str, detail_key: str) -> List[str]:
    """
    Supports common payload shapes:
    - EventBridge -> SQS envelope: {"detail": {"offenderIp": "1.2.3.4", ...}, ...}
    - Plain message: {"offenderIp": "1.2.3.4"}
    - Multiple IPs: {"offenderIps": ["1.2.3.4","5.6.7.8"]}
    """
    msg = json.loads(record_body)

    ips: List[str] = []

    # 1) Try configured dot-path (default detail.offenderIp)
    v = extract_dotpath(msg, detail_key)
    if isinstance(v, str) and v.strip():
        ips.append(v.strip())

    # 2) Try common alternatives
    if not ips:
        if isinstance(msg.get("offenderIp"), str):
            ips.append(msg["offenderIp"].strip())

    # 3) Optional list
    if isinstance(msg.get("offenderIps"), list):
        for x in msg["offenderIps"]:
            if isinstance(x, str) and x.strip():
                ips.append(x.strip())

    return ips

def waf_client(region: str):
    return boto3.client("wafv2", region_name=region)

def sns_client():
    return boto3.client("sns")

def update_ip_set_additions(
    waf,
    scope: str,
    ip_set_id: str,
    ip_set_name: str,
    additions: Set[str],
) -> Tuple[List[str], List[str]]:
    """
    Returns (added, skipped_already_present)
    """
    resp = waf.get_ip_set(Name=ip_set_name, Scope=scope, Id=ip_set_id)
    lock_token = resp["LockToken"]
    current_addresses = resp["IPSet"]["Addresses"]
    current_set = set(current_addresses)

    to_add = sorted(list(additions - current_set))
    already = sorted(list(additions & current_set))

    if not to_add:
        return [], already

    new_addresses = current_addresses + to_add

    waf.update_ip_set(
        Name=ip_set_name,
        Scope=scope,
        Id=ip_set_id,
        LockToken=lock_token,
        Addresses=new_addresses,
    )
    return to_add, already

def publish_admin_notification(topic_arn: str, subject: str, message: str) -> None:
    sns = sns_client()
    sns.publish(
        TopicArn=topic_arn,
        Subject=subject[:100],  # SNS subject max 100 chars
        Message=message,
    )

def lambda_handler(event, context):
    scope = get_env("WAF_SCOPE").upper()                # REGIONAL or CLOUDFRONT
    region = get_env("WAF_REGION")                     # CLOUDFRONT must be us-east-1
    ip_set_id = get_env("WAF_IP_SET_ID")
    ip_set_name = get_env("WAF_IP_SET_NAME")
    topic_arn = get_env("SNS_TOPIC_ARN")

    detail_key = os.environ.get("EVENT_DETAIL_KEY", "detail.offenderIp")
    ban_message = os.environ.get("BAN_MESSAGE", "Banned by automation")
    max_ips = int(os.environ.get("MAX_IPS_PER_UPDATE", "500"))

    if scope not in ("REGIONAL", "CLOUDFRONT"):
        raise RuntimeError("WAF_SCOPE must be REGIONAL or CLOUDFRONT")

    records = event.get("Records", [])
    log(f"{utc_ts()} INFO records={len(records)} scope={scope} waf_region={region}")

    normalized_ips: Set[str] = set()
    bad_entries: List[str] = []

    for r in records:
        body = r.get("body", "")
        try:
            ips = parse_offender_ips_from_sqs_record(body, detail_key)
            for ip in ips:
                try:
                    normalized_ips.add(normalize_ip_to_cidr(ip))
                except ValueError:
                    bad_entries.append(ip)
        except Exception as e:
            bad_entries.append(f"unparseable_body: {str(e)}")

    # Safety cap
    if len(normalized_ips) > max_ips:
        normalized_ips = set(sorted(normalized_ips)[:max_ips])

    added: List[str] = []
    already: List[str] = []
    error: str | None = None

    try:
        waf = waf_client(region)
        added, already = update_ip_set_additions(
            waf=waf,
            scope=scope,
            ip_set_id=ip_set_id,
            ip_set_name=ip_set_name,
            additions=normalized_ips,
        )
    except ClientError as e:
        error = f"AWS error updating IP set: {e}"
        raise
    except Exception as e:
        error = f"Error updating IP set: {e}"
        raise
    finally:
        # Always notify admin (success or failure context included)
        subject = f"WAF ban update ({scope})"
        msg = {
            "timestamp": utc_ts(),
            "action": "waf_ipset_append",
            "scope": scope,
            "waf_region": region,
            "ip_set_name": ip_set_name,
            "ip_set_id": ip_set_id,
            "requested_count": len(normalized_ips),
            "added": added,
            "already_present": already,
            "invalid_inputs": bad_entries,
            "note": ban_message,
            "error": error,
        }
        publish_admin_notification(
            topic_arn=topic_arn,
            subject=subject,
            message=json.dumps(msg, indent=2),
        )

    return {
        "requested_count": len(normalized_ips),
        "added_count": len(added),
        "already_present_count": len(already),
        "invalid_count": len(bad_entries),
        "added": added,
    }