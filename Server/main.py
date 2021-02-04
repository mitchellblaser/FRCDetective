# FRC Detective
# main.py
# Created 4-2-21

_maxpacket = 1024

##Python standard libs
import socket

##Our custom deps
import ParseArgument



##Parse arguments from command line
_args = ParseArgument.parseArgs()
_address = _args[0]
_port = _args[1]
debug = _args[2]

#Do TCP/IP Stuff
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
				##TODO: Do stuff with the data.
				connection.sendall(b'OK')
			else:
				print("No data recieved from client. Restarting.")
				break
	finally:
		connection.close()