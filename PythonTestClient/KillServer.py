_maxpacket = 1024

from socket import *
import socket
import sys

target_addr = sys.argv[1]

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = (target_addr, 5584)
sock.connect(server_address)
sock.sendall(b'Q')
