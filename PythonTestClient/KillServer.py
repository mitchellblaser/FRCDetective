_maxpacket = 1024

from socket import *
import socket
import sys

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = (sys.argv[1], 5584)
sock.connect(server_address)

sock.sendall(b'Q')