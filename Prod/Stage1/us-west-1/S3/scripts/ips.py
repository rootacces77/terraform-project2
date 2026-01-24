#!/usr/bin/env python3
import argparse
import ipaddress
import json
import random
from datetime import datetime

import boto3

def random_ip_from_cidr(cidr: str) -> str:
    net = ipaddress.ip_network(cidr, strict=False)

    if net.num_addresses <= 4:
        return str(random.choice(list(net.hosts())))

    # Choose a random host address without materializing hosts()
    if net.version == 4:
        first = int(net.network_address) + 1
        last  = int(net.broadcast_address) - 1
    else:
        first = int(net.network_address) + 1
        last  = int(net.network_address) + net.num_addresses - 1

    return str(ipaddress.ip_address(random.randint(first, last)))

def main():
    ap = argparse.ArgumentParser(description="Emit an EventBridge event with a random IP address in the text payload.")
    ap.add_argument("--event-bus", default="default", help="EventBridge bus name (default: default)")
    ap.add_argument("--cidr", default="203.0.113.0/24", help="CIDR to generate random IP from (default: 203.0.113.0/24)")
    ap.add_argument("--source", default="gwlb.sim", help="Event source string")
    ap.add_argument("--detail-type", default="RandomIpGenerated", help="Event detail-type")
    ap.add_argument("--message", default="Malformed traffic detected", help="Message text")
    args = ap.parse_args()

    events = boto3.client("events")

    ip = random_ip_from_cidr(args.cidr)
    detail = {
        "offenderIp": ip,
        "text": f"{args.message} offenderIp={ip}",
        "generatedAt": datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
    }

    resp = events.put_events(
        Entries=[
            {
                "EventBusName": args.event_bus,
                "Source": args.source,
                "DetailType": args.detail_type,
                "Time": datetime.utcnow(),
                "Detail": json.dumps(detail),
            }
        ]
    )

    # Print what we sent + AWS response metadata
    print(json.dumps({"sent": detail, "put_events_response": resp}, indent=2))

if __name__ == "__main__":
    main()