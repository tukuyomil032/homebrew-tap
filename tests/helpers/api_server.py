#!/usr/bin/env python3
"""Serve a fixture directory as a fake GitHub API for the bats tests.

Binds an ephemeral port and prints it to stdout as the first line, flushed, so
the bats helper never has to parse http.server's own banner — that banner is
buffered and its wording is not a contract.

Serving real files over real HTTP means the tests exercise the actual curl
invocation and the actual status codes, including the 404 that a repository
without a stable release produces. Request logs go to stderr.
"""

import functools
import http.server
import os
import socketserver
import sys


class Handler(http.server.SimpleHTTPRequestHandler):
    """Static file handler with a way to force an HTTP status.

    When a sibling file named "<path>.status" exists, its contents are sent as
    the status code instead of serving "<path>". That is how the tests reach the
    "unexpected HTTP status" branch without waiting for a real GitHub outage.
    """

    def send_head(self):
        override = self.translate_path(self.path) + ".status"
        if os.path.isfile(override):
            with open(override, encoding="utf-8") as handle:
                self.send_error(int(handle.read().strip()))
            return None
        return super().send_head()


class Server(socketserver.TCPServer):
    allow_reuse_address = True


def main() -> int:
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <fixture-root>", file=sys.stderr)
        return 1

    handler = functools.partial(Handler, directory=sys.argv[1])
    # TCPServer binds and listens in its constructor, so a client that sees the
    # port below is guaranteed to connect even before serve_forever() runs.
    with Server(("127.0.0.1", 0), handler) as httpd:
        print(httpd.server_address[1], flush=True)
        httpd.serve_forever()
    return 0


if __name__ == "__main__":
    sys.exit(main())
