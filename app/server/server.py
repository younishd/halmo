#!/usr/bin/env python3
# --[[
# --
# -- Halmö
# --
# -- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
# --
# --]]

import os
import sys
import logging
import argparse
import socket
import socketserver
import threading
from struct import *
from binascii import *
from hashlib import *
import lupa
from lupa import LuaRuntime

class Game:
    def __init__(self, players):
        self.players = players
        number_players = len(players)
        self.engine = lua.eval("Engine(Board( python.eval('number_players') ))")

    def move(self, src, dst):
        return self.engine.move(self.engine, src, dst)

    def finish(self):
        return self.engine.finish(self.engine)

class Room:
    def __init__(self, name, capacity, owner):
        self.name = name
        self.capacity = capacity
        self.owner = owner
        self.game = None

class Lobby:
    def __init__(self):
        self.rooms = {}
        self.players = {}
        self.callbacks = {}
        self.locks = {}
        self.locks['rooms'] = threading.Lock()
        self.locks['players'] = threading.Lock()
        self.locks['callbacks'] = threading.Lock()

class ClientHandler(socketserver.BaseRequestHandler):
    def setup(self):
        pass

    def handle(self):
        log.info("client connected: {}".format(self.request.getpeername()))

    def finish(self):
        log.info("client disconnected: {}".format(self.request.getpeername()))

class ThreadingTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    allow_reuse_address = True

def foo():
    log.debug("foo()")
    game = Game([1, 2, 3])
    game.move({ 'x':1, 'y':5 }, { 'x':1, 'y':4 })
    game.finish()
    sys.exit(0)

def main():
    logging.basicConfig(
            format='[%(levelname)s] [%(asctime)s] [%(name)-5s] [%(threadName)-12s]  %(message)s',
            level=logging.DEBUG,
            datefmt='%H:%M:%S')
    logging.addLevelName(logging.DEBUG, '*')
    logging.addLevelName(logging.INFO, '+')
    logging.addLevelName(logging.WARNING, '!')
    logging.addLevelName(logging.ERROR, '-')
    logging.addLevelName(logging.CRITICAL, '-')
    global log
    log = logging.getLogger("main")

    log.info("initializing Lua runtime...")
    global lua
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute("package.path = package.path .. ';../src/?.lua;../lib/?.lua'")
    lua.execute("require 'env'")
    lua.execute("log = python.eval('logging.getLogger(\"lua\")')")
    lua.execute("logo()")

    parser = argparse.ArgumentParser(description="Halmö dedicated server")
    parser.add_argument('host')
    parser.add_argument('port', type=int)
    args = parser.parse_args()

    log.info("starting server...")

    foo()

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
