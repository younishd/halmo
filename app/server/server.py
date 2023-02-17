#!/usr/bin/env python3
# --[[
# --
# -- Halmö
# --
# -- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmailog.com>
# --
# --]]

import os
import sys
import platform
import logging as log
import argparse
import socket
import socketserver
import threading
from binascii import *
from hashlib import *
import lupa

from contextlib import contextmanager
from pathlib import Path
from select import select
from struct import pack, unpack

import halmo_pb2 as h
from google.protobuf.any_pb2 import Any
from google.protobuf.message import DecodeError


class Server:
    class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
        allow_reuse_address = True
        daemon_threads = True

    class TCPHandler(socketserver.BaseRequestHandler):
        def handle(self):
            host, port = self.client_address
            log.info(f"accepted connection from {self.client_address[0]}:{self.client_address[1]}")

            msg = self.recv()
            if msg.WhichOneof("type") == "player":
                log.info(f"player {msg.player.name} joined!")
                status = h.Status()
                status.code = h.StatusCode.OK
                response = h.Message()
                response.status.CopyFrom(status)
                self.send(response)
            else:
                log.warning("undefined type")

        def send(self, message):
            payload = message.SerializeToString()
            try:
                self.request.sendall(pack(">I", len(payload)) + payload)
            except socket.error as e:
                log.error("socket error: {}".format(repr(e)))
                return False
            return True

        def recv(self):
            def recv_data():
                ready = select([self.request], [], [])
                if not ready[0]:
                    log.error("failed to select()")
                    return False
                header = bytearray()
                while len(header) < 4:
                    header += self.request.recv(4 - len(header))
                    if not header:
                        log.error("failed to recv() header")
                        return False
                (length,) = unpack(">I", header)
                payload = bytearray()
                bytes_read = 0
                while bytes_read < length:
                    buf = self.request.recv(length - bytes_read)
                    if not buf:
                        log.error("failed to recv() data")
                        return False
                    payload += buf
                    bytes_read += len(buf)
                if len(payload) != length:
                    log.error(
                        "received {} bytes, expected {} bytes".format(
                            len(payload), length
                        )
                    )
                    return False
                return bytes(payload)
            payload = recv_data()
            if not payload:
                return False
            message = h.Message()
            try:
                message.ParseFromString(payload)
            except DecodeError as e:
                log.error("failed to decode protobuf message: {}".format(repr(e)))
                return False
            return message

    def __init__(self, host, port):
        self._host = host
        self._port = port

    def start(self):
        with self.ThreadedTCPServer(
            (self._host, self._port), self.TCPHandler
        ) as server:
            server._outer = self
            log.info("listening on {}:{}".format(self._host, self._port))
            server.serve_forever()
        log.info("bye!")


# class Player:
#     def __init__(self, id):
#         self.name = ""
#         self.id = id
#         self.locks = {}
#         self.locks["self"] = threading.Lock()

#     def set_name(self, name):
#         with self.locks["self"]:
#             old_name = self.name
#             self.name = name
#             log.debug(
#                 "player <{}> changed name from <{}> to <{}>".format(
#                     self.id, old_name, self.name
#                 )
#             )


# class Game:
#     def __init__(self, players):
#         self.players = players
#         number_players = len(players)
#         self.engine = lua.eval("Engine(Board( python.eval('number_players') ))")

#     def move(self, src, dst):
#         return self.engine.move(self.engine, src, dst)

#     def finish(self):
#         return self.engine.finish(self.engine)


# class Room:
#     def __init__(self, name, number_players, owner):
#         self.name = name
#         self.number_players = number_players
#         self.owner = owner
#         self.game = None
#         self.players = set()
#         self.locks = {}
#         self.locks["players"] = threading.Lock()

#     def join(self, player):
#         with self.locks["players"]:
#             if player.id in self.players:
#                 log.warning(
#                     "player <{}> already in room <{}>".format(player.name, self.name)
#                 )
#                 return False
#             self.players.add(player)
#             log.info("<{}> joined room <{}>".format(player.name, self.name))


# class Lobby:
#     def __init__(self):
#         self.rooms = {}
#         self.players = {}
#         self.callbacks = {}
#         self.locks = {}
#         self.locks["rooms"] = threading.Lock()
#         self.locks["players"] = threading.Lock()
#         self.locks["callbacks"] = threading.Lock()

#         self.player_counter = 1

#     def join(self, player):
#         with self.locks["players"]:
#             player.set_name("Player " + str(self.player_counter))
#             self.player_counter = self.player_counter + 1
#             self.players[player.id] = player
#             log.info("<{}> joined the lobby".format(player.name))

#     def add_room(self, room):
#         with self.locks["rooms"]:
#             self.rooms[room.name] = room
#             log.debug("added room <{}> to lobby".format(room.name))


# class ClientHandler(socketserver.BaseRequestHandler):
#     def setup(self):
#         pass

#     def handle(self):
#         lobby = self.server.lobby
#         host, port = self.client_address
#         log.info("client connected: {}:{}".format(host, port))

#         player = Player(sha1("{}:{}".format(host, port).encode()).hexdigest())
#         lobby.join(player)
#         room = Room("Room 1", 16, player)
#         lobby.add_room(room)
#         room.join(player)

#         while True:
#             pass

#     def finish(self):
#         log.info("client disconnected: {}".format(self.request.getpeername()))


class CustomFormatter(log.Formatter):
    RED = "\x1b[31m"
    GREEN = "\x1b[32m"
    YELLOW = "\x1b[33m"
    CYAN = "\x1b[36m"
    GREY = "\x1b[38m"
    RESET = "\x1b[0m"
    FORMAT = "%(message)s"

    def __init__(self):
        super().__init__()
        self._formats = {
            log.DEBUG: self.GREY + "[*]  " + self.FORMAT + self.RESET,
            log.INFO: self.GREEN + "[+]  " + self.FORMAT + self.RESET,
            log.WARNING: self.YELLOW + "[!]  " + self.FORMAT + self.RESET,
            log.ERROR: self.RED + "[-]  " + self.FORMAT + self.RESET,
        }

    def format(self, record):
        log_fmt = self._formats.get(record.levelno)
        formatter = log.Formatter(log_fmt)
        return formatter.format(record)


@contextmanager
def nonblocking(lock):
    locked = lock.acquire(False)
    try:
        yield locked
    finally:
        if locked:
            lock.release()


def main():
    # configure logging
    ch = log.StreamHandler()
    ch.setFormatter(CustomFormatter())
    ch.setLevel(log.DEBUG)
    log.getLogger().addHandler(ch)
    log.getLogger().setLevel(log.DEBUG)
    lua_log = log.getLogger("lua")
    lua_log.setLevel(log.DEBUG)

    # init lua runtime
    global lua
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    log.debug(
        f"using {lua.lua_implementation} (compiled with {lupa.LUA_VERSION[0]}.{lupa.LUA_VERSION[1]})"
    )
    lua.execute("require 'env_server'")
    lua.execute("log = python.eval('lua_log')")

    parser = argparse.ArgumentParser(
        description="Halmö - dedicated server", prog="halmo-server"
    )
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=33333)
    parser.add_argument(
        "--version", action="version", version=lua.eval("version()")
    )
    args = parser.parse_args()

    lua.execute("log.debug('lua runtime is armed...')")
    lua.execute("logo()")
    log.debug("version: " + lua.eval("version()"))
    log.debug("by: Younis Bensalah")
    log.debug("platform: " + platform.platform())

    # start server
    Server(args.host, args.port).start()

if __name__ == "__main__":
    main()
