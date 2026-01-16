import os
import json
import time
import uuid
import boto3
from typing import Any, Dict, List

kinesis = boto3.client("kinesis")

STREAM_NAME = os.environ.get("KINESIS_STREAM_NAME", "")
DEFAULT_PARTITION_KEY = os.environ.get("DEFAULT_PARTITION_KEY", "source-a")


def _to_bytes(obj: Any) -> bytes:
    """
    Convert payload to bytes for Kinesis.
    Kinesis Data Streams expects bytes; boto3 accepts bytes/str; we use bytes explicitly.
    """
    if isinstance(obj, (bytes, bytearray)):
        return bytes(obj)
    if isinstance(obj, str):
        return obj.encode("utf-8")
    return json.dumps(obj, separators=(",", ":"), ensure_ascii=False).encode("utf-8")


def _normalize_records(event: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Accept either:
      - {"records": [ ... ]} (batch)
      - any other object (single payload)
    Each record can be any JSON-serializable object.
    """
    if isinstance(event, dict) and isinstance(event.get("records"), list):
        return event["records"]
    return [event]


def handler(event: Dict[str, Any], context) -> Dict[str, Any]:
    if not STREAM_NAME:
        raise RuntimeError("KINESIS_STREAM_NAME env var is not set")

    records = _normalize_records(event)

    # Optional: per-request override
    partition_key = (
        event.get("partition_key")
        if isinstance(event, dict)
        else None
    ) or DEFAULT_PARTITION_KEY

    # Enrich and serialize each record
    enriched = []
    now_ms = int(time.time() * 1000)

    for r in records:
        enriched.append(
            {
                "event_id": str(uuid.uuid4()),
                "source": "lambda-source-a",
                "ts_ms": now_ms,
                "payload": r,
            }
        )

    # Use PutRecords for better throughput when batch is provided
    if len(enriched) > 1:
        entries = [{"Data": _to_bytes(item), "PartitionKey": partition_key} for item in enriched]
        resp = kinesis.put_records(StreamName=STREAM_NAME, Records=entries)

        failed = resp.get("FailedRecordCount", 0)
        return {
            "ok": failed == 0,
            "stream": STREAM_NAME,
            "sent": len(entries),
            "failed": failed,
            "response": {
                "FailedRecordCount": failed,
            },
        }

    # Single record
    resp = kinesis.put_record(
        StreamName=STREAM_NAME,
        Data=_to_bytes(enriched[0]),
        PartitionKey=partition_key,
    )

    return {
        "ok": True,
        "stream": STREAM_NAME,
        "sent": 1,
        "shard_id": resp.get("ShardId"),
        "sequence_number": resp.get("SequenceNumber"),
    }