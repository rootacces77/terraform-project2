import os
import json
import base64
import uuid
from datetime import datetime, timezone

import boto3

TABLE_NAME = os.environ["TABLE_NAME"]
ddb = boto3.resource("dynamodb")
table = ddb.Table(TABLE_NAME)


ORIGIN_VERIFY_HEADER = os.environ.get("ORIGIN_VERIFY_HEADER", "X-Origin-Verify")
ORIGIN_VERIFY_SECRET = os.environ.get("ORIGIN_VERIFY_SECRET", "")

def _get_header(event, name: str):
    headers = event.get("headers") or {}
    # API Gateway headers can vary in case; normalize to lowercase
    headers_lc = {k.lower(): v for k, v in headers.items() if isinstance(k, str)}
    return headers_lc.get(name.lower())

def handler(event, context):
    provided = _get_header(event, ORIGIN_VERIFY_HEADER)

    if not ORIGIN_VERIFY_SECRET or provided != ORIGIN_VERIFY_SECRET:
        return {
            "statusCode": 403,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"ok": False, "message": "Forbidden"}),
        }


def _json_response(status_code: int, payload: dict) -> dict:
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
        },
        "body": json.dumps(payload),
    }


def handler(event, context):
    try:
        body_str = event.get("body") or ""

        if event.get("isBase64Encoded"):
            body_str = base64.b64decode(body_str).decode("utf-8", errors="replace")

        body = json.loads(body_str) if body_str else {}
        user_input = str(body.get("input", "")).strip()

        if not user_input:
            return _json_response(400, {
                "ok": False,
                "message": "Missing 'input' in request body."
            })

        pk = f"req#{uuid.uuid4()}"
        created_at = datetime.now(timezone.utc).isoformat()

        table.put_item(
            Item={
                "pk": pk,
                "input": user_input,
                "created_at": created_at,
            }
        )

        return _json_response(200, {
            "ok": True,
            "pk": pk,
            "created_at": created_at
        })

    except Exception as e:
        return _json_response(500, {
            "ok": False,
            "message": "Internal error",
            "error": str(e),
        })