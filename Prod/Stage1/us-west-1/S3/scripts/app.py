#!/usr/bin/env python3
import argparse
import os
import signal
import socket
import sys
from datetime import datetime

RUNNING = True

def utc_ts() -> str:
    return datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

def handle_stop(signum, frame):
    global RUNNING
    RUNNING = False

def ensure_log_dir(path: str) -> None:
    d = os.path.dirname(os.path.abspath(path))
    if d and not os.path.exists(d):
        os.makedirs(d, exist_ok=True)

def log(fp, src_ip: str, src_port: int | None):
    if src_port is None:
        fp.write(f"{utc_ts()} ip={src_ip}\n")
    else:
        fp.write(f"{utc_ts()} ip={src_ip} port={src_port}\n")
    fp.flush()

def serve_udp(bind_ip: str, port: int, log_file: str) -> int:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.bind((bind_ip, port))
    s.settimeout(1.0)

    ensure_log_dir(log_file)
    with open(log_file, "a", buffering=1) as fp:
        fp.write(f"{utc_ts()} INFO udp_listen bind={bind_ip}:{port}\n")
        fp.flush()

        while RUNNING:
            try:
                _data, (src_ip, src_port) = s.recvfrom(65535)
                log(fp, src_ip, src_port)
            except socket.timeout:
                continue
            except OSError as e:
                if RUNNING:
                    fp.write(f"{utc_ts()} ERROR udp_recv err={e}\n")
                break

        fp.write(f"{utc_ts()} INFO udp_stop\n")
    s.close()
    return 0

def serve_tcp(bind_ip: str, port: int, log_file: str) -> int:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((bind_ip, port))
    s.listen(128)
    s.settimeout(1.0)

    ensure_log_dir(log_file)
    with open(log_file, "a", buffering=1) as fp:
        fp.write(f"{utc_ts()} INFO tcp_listen bind={bind_ip}:{port}\n")
        fp.flush()

        while RUNNING:
            try:
                conn, (src_ip, src_port) = s.accept()
            except socket.timeout:
                continue
            except OSError as e:
                if RUNNING:
                    fp.write(f"{utc_ts()} ERROR tcp_accept err={e}\n")
                break

            # Log connect event
            log(fp, src_ip, src_port)

            # Drain minimal data then close (we only need IP/timestamp)
            try:
                conn.settimeout(0.5)
                try:
                    conn.recv(1)
                except socket.timeout:
                    pass
            finally:
                try:
                    conn.close()
                except OSError:
                    pass

        fp.write(f"{utc_ts()} INFO tcp_stop\n")
    s.close()
    return 0

def main() -> int:
    p = argparse.ArgumentParser(description="Listen on TCP/UDP and log timestamp + source IP to a file.")
    p.add_argument("--port", "-port", type=int, required=True, help="Port to listen on (1-65535)")
    p.add_argument("--protocol", "-protocol", choices=["tcp", "udp"], required=True, help="Protocol: tcp or udp")
    p.add_argument("--log-file", required=True, help="Log file path")
    p.add_argument("--bind", default="0.0.0.0", help="Bind address (default 0.0.0.0)")
    args = p.parse_args()

    if not (1 <= args.port <= 65535):
        print("ERROR: --port must be 1-65535", file=sys.stderr)
        return 2

    signal.signal(signal.SIGINT, handle_stop)
    signal.signal(signal.SIGTERM, handle_stop)

    if args.protocol == "udp":
        return serve_udp(args.bind, args.port, args.log_file)
    return serve_tcp(args.bind, args.port, args.log_file)

if __name__ == "__main__":
    raise SystemExit(main())