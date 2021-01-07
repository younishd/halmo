#!/usr/bin/env python3

import socket

def main():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect(("localhost", 1337))
        s.sendall(b'Hi there')
        data = s.recv(1024)

    print(repr(data))

if __name__ == '__main__':
    main()
