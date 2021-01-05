#!/usr/bin/env python3
# --[[
# --
# -- Halmö
# --
# -- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
# --
# --]]

import logging as log
import argparse
import socket
import socketserver
import threading
from struct import *
from binascii import *
from hashlib import *

class ClientHandler(socketserver.BaseRequestHandler):
    def setup(self):
        pass

    def handle(self):
        log.info("client connected: {}".format(self.request.getpeername()))

    def finish(self):
        log.info("client disconnected: {}".format(self.request.getpeername()))

class ThreadingTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    allow_reuse_address = True

def main():
    log.basicConfig(
        format='[%(asctime)s] [%(levelname)s]  %(message)s',
        level=log.DEBUG,
        datefmt='%H:%M:%S')

    parser = argparse.ArgumentParser(description="Halmö dedicated server")
    parser.add_argument('host')
    parser.add_argument('port', type=int)
    args = parser.parse_args()

    log.info("starting server...")

    with ThreadingTCPServer((args.host, args.port), ClientHandler) as server:
        host, port = server.server_address
        log.info("listening on {}:{}".format(host, port))

        server_thread = threading.Thread(target=server.serve_forever)
        server_thread.daemon = True
        server_thread.start()

        try:
            server_thread.join()
        except KeyboardInterrupt as e:
            log.debug(repr(e))

        log.info("shutting down server...")
        server.shutdown()

        log.info("bye!")

if __name__ == '__main__':
    main()
