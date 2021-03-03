_maxpacket = 1024

from socket import *
import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = ("10.10.10.161", 5584)
sock.connect(server_address)

sock.sendall(b'Q')