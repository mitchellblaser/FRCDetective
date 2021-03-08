#!/usr/bin/python3

from socket import *
import socket

import threading

def OnConnection(connection, address):
    print("Connection from " + str(address) + ".")

    while True:
        data = connection.recv(1024)
        if data:
            print(data)
        else:
            connection.close()
            return

_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
_socket.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
_server_addr = ('127.0.0.1', 5584)
print("Starting main server on {}:{}.".format(*_server_addr))
_socket.bind(_server_addr)
_socket.listen(1)

while True:
    connection, address = _socket.accept()
    thread = threading.Thread(target=OnConnection, args=(connection, address))
    thread.start()