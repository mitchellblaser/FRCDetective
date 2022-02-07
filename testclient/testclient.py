#!/usr/bin/python3
import socket
import json

HOST = "127.0.0.1"
PORT = 5584

DATA = {
    "request": "PUT_TEAM",
    "from": ["username", "password"],
    "data": {
        "teamnumber": "5584"
    }
}

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    s.sendall(json.dumps(DATA).encode("utf-8"))
    print(s.recv(1024))
