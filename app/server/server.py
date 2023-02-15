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
from lupa import LuaRuntime

import socket as s
from contextlib import contextmanager
from pathlib import Path
from select import select
from struct import pack, unpack

from halmo_pb2 import *
from google.protobuf.any_pb2 import Any
from google.protobuf.message import DecodeError


class Server:
    class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
        allow_reuse_address = True
        daemon_threads = True

    class TCPHandler(socketserver.BaseRequestHandler):
        def handle(self):
            host, port = self.client_address
            log.info("client connected: {}:{}".format(host, port))

        def send_msg(self, msg):
            message = Message()
            message.Pack(msg)
            payload = message.SerializeToString()
            try:
                self.request.sendall(pack(">I", len(payload)) + payload)
            except s.error as e:
                log.error("socket error: {}".format(repr(e)))
                return False
            return True

        def recv_msg(self, sock):
            def recv_data():
                nonlocal sock
                ready = select([sock], [], [])
                if not ready[0]:
                    log.error("select() returned nothing")
                    return False
                header = bytearray()
                while len(header) < 4:
                    header += sock.recv(4 - len(header))
                    if not header:
                        log.error("failed to recv() header")
                        return False
                (length,) = unpack(">I", header)
                data = bytearray()
                bytes_read = 0
                while bytes_read < length:
                    buf = sock.recv(length - bytes_read)
                    if not buf:
                        log.error("failed to recv() data")
                        return False
                    data += buf
                    bytes_read += len(buf)
                if len(data) != length:
                    log.error(
                        "failed to receive message: received {} bytes, expected {} bytes".format(
                            len(data), length
                        )
                    )
                    return False
                return bytes(data)

            data = recv_data()
            if not data:
                return False
            message = Message()
            try:
                message.ParseFromString(data)
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


def init_logger(log_file=None, verbosity=1, show_proc_thread_name=False):
    if hasattr(log, "TRACE"):
        return

    class CustomFormatter(log.Formatter):
        RED = "\x1b[31m"
        GREEN = "\x1b[32m"
        YELLOW = "\x1b[33m"
        CYAN = "\x1b[36m"
        GREY = "\x1b[38m"
        RESET = "\x1b[0m"
        FORMAT = "%(message)s"
        PROC_THREAD = (
            "(%(processName)s - %(threadName)s)  " if show_proc_thread_name else ""
        )

        def __init__(self):
            super().__init__()
            self._formats = {
                log.TRACE: self.CYAN
                + "[/]  "
                + self.PROC_THREAD
                + self.FORMAT
                + self.RESET,
                log.DEBUG: self.GREY
                + "[*]  "
                + self.PROC_THREAD
                + self.FORMAT
                + self.RESET,
                log.INFO: self.GREEN
                + "[+]  "
                + self.PROC_THREAD
                + self.FORMAT
                + self.RESET,
                log.WARNING: self.YELLOW
                + "[!]  "
                + self.PROC_THREAD
                + self.FORMAT
                + self.RESET,
                log.ERROR: self.RED
                + "[-]  "
                + self.PROC_THREAD
                + self.FORMAT
                + self.RESET,
            }

        def format(self, record):
            log_fmt = self._formats.get(record.levelno)
            formatter = log.Formatter(log_fmt)
            return formatter.format(record)

    # register trace level
    setattr(log, "TRACE", log.DEBUG - 5)
    setattr(
        log.getLoggerClass(),
        "trace",
        lambda self, m, *args, **kwargs: self.isEnabledFor(log.TRACE)
        and self._log(log.TRACE, m, args, **kwargs),
    )
    setattr(
        log, "trace", lambda m, *args, **kwargs: log.log(log.TRACE, m, *args, **kwargs)
    )
    log.addLevelName(log.TRACE, "TRACE")
    log.getLogger().setLevel(log.TRACE)

    # register stream handler
    ch = log.StreamHandler()
    ch.setFormatter(CustomFormatter())
    ch.setLevel(log.INFO)
    if verbosity > 1:
        ch.setLevel(log.TRACE)
    elif verbosity > 0:
        ch.setLevel(log.DEBUG)
    log.getLogger().addHandler(ch)

    # register file handler
    if log_file is not None:
        fh = log.FileHandler(log_file)
        fh.setLevel(log.DEBUG)
        fh.setFormatter(
            log.Formatter(
                fmt="%(asctime)s [%(levelname)-8s] %(message)s",
                datefmt="%Y-%m-%d %H:%M:%S",
            )
        )
        log.getLogger().addHandler(fh)


# def foo():
#     log.debug("foo()")
#     game = Game([1, 2, 3])
#     game.move({"x": 1, "y": 5}, {"x": 1, "y": 4})
#     game.finish()
#     sys.exit(0)


@contextmanager
def nonblocking(lock):
    locked = lock.acquire(False)
    try:
        yield locked
    finally:
        if locked:
            lock.release()


def main():
    init_logger()

    global lua
    lua = LuaRuntime(unpack_returned_tuples=True)
    # TODO fuck this
    lua.execute(
        "package.path = 'app/?.lua;app/src/?.lua;app/src/lib/?/?.lua;../.luarocks/share/lua/5.1/?.lua;../.luarocks/share/lua/5.1/?/init.lua;' .. package.path"
    )
    lua.execute("package.cpath = '../.luarocks/lib/lua/5.1/?.so;' .. package.cpath")
    lua.execute("require 'env'")
    lua.execute("log = python.eval('logging.getLogger(\"lua\")')")

    parser = argparse.ArgumentParser(
        description="Halmö - dedicated server", prog="halmo-server"
    )
    parser.add_argument("host")
    parser.add_argument("port", type=int)
    parser.add_argument(
        "--version", action="version", version="%(prog)s " + lua.eval("version")
    )
    args = parser.parse_args()

    lua.execute("log.info('lua runtime is ready to go...')")
    lua.execute("logo()")
    log.info("version: " + lua.eval("version"))
    log.info("by: Younis Bensalah")
    log.debug("platform: " + platform.platform())

    s = Server("127.0.0.1", 44444)
    s.start()


if __name__ == "__main__":
    main()
