import os
import json
import time
import uuid
import hashlib
import boto3
from typing import Any, Dict, List

kinesis = boto3.client("kinesis")

STREAM_NAME = os.environ.get("KINESIS_STREAM_NAME", "")
DEFAULT_PARTITION_KEY = os.environ.get("DEFAULT_PARTITION_KEY", "source-b")


def _to_bytes(obj: Any) -> bytes:
    if isinstance(obj, (bytes, bytearray)):
        return bytes(obj)
    if isinstance(obj, str):
        return obj.encode("utf-8")
    return json.dumps(obj, separators=(",", ":"), ensure_ascii=False).encode("utf-8")


def _normalize_records(event: Dict[str, Any]) -> List[Dict[str, Any]]:
    if isinstance(event, dict) and isinstance(event.get("records"), list):
        return event["records"]
    return [event]


def _stable_partition_key(record: Any) -> str:
    """
    If you want more even distribution across shards, derive a stable key from content.
    (Firehose can still split to different S3 prefixes/buckets downstream if you configure it.)
    """
    raw = json.dumps(record, sort_keys=True, default=str).encode("utf-8")
    return hashlib.sha256(raw).hexdigest()[:32]


def handler(event: Dict[str, Any], context) -> Dict[str, Any]:
    if not STREAM_NAME:
        raise RuntimeError("KINESIS_STREAM_NAME env var is not set")

    records = _normalize_records(event)
    now_ms = int(time.time() * 1000)

    enriched = []
    for r in records:
        enriched.append(
            {
                "event_id": str(uuid.uuid4()),
                "source": "lambda-source-b",
                "ts_ms": now_ms,
                "payload": r,
            }
        )

    # Optional override: event["partition_key_mode"] = "stable" | "fixed"
    mode = "fixed"
    if isinstance(event, dict) and event.get("partition_key_mode") in ("stable", "fixed"):
        mode = event["partition_key_mode"]

    if len(enriched) > 1:
        entries = []
        for item in enriched:
            pk = DEFAULT_PARTITION_KEY if mode == "fixed" else _stable_partition_key(item["payload"])
            entries.append({"Data": _to_bytes(item), "PartitionKey": pk})

        resp = kinesis.put_records(StreamName=STREAM_NAME, Records=entries)
        failed = resp.get("FailedRecordCount", 0)

        return {
            "ok": failed == 0,
            "stream": STREAM_NAME,
            "sent": len(entries),
            "failed": failed,
            "partition_key_mode": mode,
        }

    pk = DEFAULT_PARTITION_KEY if mode == "fixed" else _stable_partition_key(enriched[0]["payload"])
    resp = kinesis.put_record(StreamName=STREAM_NAME, Data=_to_bytes(enriched[0]), PartitionKey=pk)

    return {
        "ok": True,
        "stream": STREAM_NAME,
        "sent": 1,
        "partition_key_mode": mode,
        "shard_id": resp.get("ShardId"),
        "sequence_number": resp.get("SequenceNumber"),
    }