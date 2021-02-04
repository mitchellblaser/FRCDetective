# FRC Detective
# main.py
# Created 4-2-21

_address = 'localhost'
_port = 5584
_maxpacket = 1024

import socket

_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
_server_addr = (_address, _port)

if debug: print("Starting server on {}:{}.".format(*_server_addr))
_socket.bind(_server_addr)


_socket.listen(1)

while True:
	if debug: print("Waiting for client connection.")
	connection, client_address = _socket.accept()
	try:
		print("Connection from " + client_address)

		while True:
			data = connection.recv(_maxpacket)
			if data:
				connection.sendall(b'OK')
