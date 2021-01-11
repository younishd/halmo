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
import platform
import logging
import argparse
import socket
from socketserver import ThreadingTCPServer, BaseRequestHandler
import threading
from struct import *
from binascii import *
from hashlib import *
import lupa
from lupa import LuaRuntime

class Player:
    def __init__(self, id):
        self.name = ""
        self.id = id
        self.locks = {}
        self.locks['self'] = threading.Lock()

    def set_name(self, name):
        with self.locks['self']:
            old_name = self.name
            self.name = name
            log.debug("player <{}> changed name from <{}> to <{}>".format(self.id, old_name, self.name))

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
        self.players = set()
        self.locks = {}
        self.locks['players'] = threading.Lock()

    def join(self, player):
        with self.locks['players']:
            if player.id in self.players:
                log.warning("player <{}> already in room <{}>".format(player.name, self.name))
                return False
            self.players.add(player)
            log.info("<{}> joined room <{}>".format(player.name, self.name))

class Lobby:
    def __init__(self):
        self.rooms = {}
        self.players = {}
        self.callbacks = {}
        self.locks = {}
        self.locks['rooms'] = threading.Lock()
        self.locks['players'] = threading.Lock()
        self.locks['callbacks'] = threading.Lock()

        self.player_counter = 1

    def join(self, player):
        with self.locks['players']:
            player.set_name("Player " + str(self.player_counter))
            self.player_counter = self.player_counter + 1
            self.players[player.id] = player
            log.info("<{}> joined the lobby".format(player.name))

    def add_room(self, room):
        with self.locks['rooms']:
            self.rooms[room.name] = room
            log.debug("added room <{}> to lobby".format(room.name))

class ClientHandler(BaseRequestHandler):
    def setup(self):
        pass

    def handle(self):
        lobby = self.server.lobby
        host, port = self.client_address
        log.info("client connected: {}:{}".format(host, port))

        player = Player(sha1("{}:{}".format(host, port).encode()).hexdigest())
        lobby.join(player)
        room = Room("Room 1", 16, player)
        lobby.add_room(room)
        room.join(player)

        while True:
            pass

    def finish(self):
        log.info("client disconnected: {}".format(self.request.getpeername()))

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

    global lua
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute("package.path = package.path .. ';../src/?.lua;../lib/?.lua'")
    lua.execute("require 'env'")
    lua.execute("log = python.eval('logging.getLogger(\"lua\")')")

    parser = argparse.ArgumentParser(description="Halmö dedicated server", prog='halmo-server')
    parser.add_argument('host')
    parser.add_argument('port', type=int)
    parser.add_argument('--version', action='version', version="%(prog)s " + lua.eval("version"))
    args = parser.parse_args()

    lua.execute("log.info('lua runtime is ready to go...')")

    lua.execute("logo()")
    log.info('version: ' + lua.eval("version"))
    log.info('by: Younis Bensalah')
    log.debug("platform: " + platform.platform())

    log.info("starting server...")
    ThreadingTCPServer.allow_reuse_address = True
    with ThreadingTCPServer((args.host, args.port), ClientHandler) as server:
        host, port = server.server_address
        log.info("listening on {}:{}".format(host, port))

        log.info("initializing lobby...")
        server.lobby = Lobby()

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
