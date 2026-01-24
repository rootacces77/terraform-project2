#!/usr/bin/env python3
import argparse
from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime

class HealthHandler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        # cleaner logs than default
        ts = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
        print(f"{ts} {self.client_address[0]}:{self.client_address[1]} {fmt % args}")

    def do_GET(self):
        if self.path == "/health":
            body = b"OK\n"
            self.send_response(200)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        else:
            body = b"Not Found\n"
            self.send_response(404)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

def main():
    ap = argparse.ArgumentParser(description="Simple /health HTTP server for load balancer health checks")
    ap.add_argument("--bind", default="0.0.0.0", help="Bind address (default 0.0.0.0)")
    ap.add_argument("--port", type=int, default=80, help="Port (default 80)")
    args = ap.parse_args()

    httpd = HTTPServer((args.bind, args.port), HealthHandler)
    print(f"Listening on http://{args.bind}:{args.port} (GET /health)")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        httpd.server_close()

if __name__ == "__main__":
    main()