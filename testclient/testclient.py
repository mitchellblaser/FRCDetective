#!/usr/bin/python3
import socket
import json

HOST = "127.0.0.1"
PORT = 5584

DATA = {
    "request": "GET_DIFF",
    "from": ["mblaser", "password"],
    "data": {}
}

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    s.sendall(json.dumps(DATA).encode("utf-8"))
