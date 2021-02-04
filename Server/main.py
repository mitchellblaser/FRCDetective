# FRC Detective
# main.py
# Created 4-2-21

_maxpacket = 1024

##Python standard libs
import socket

##Our custom deps
import ParseArgument
import Graphics
import HashScript
import Communications

##Parse arguments from command line
if ParseArgument.isEmpty() == False:
	_args = ParseArgument.parseArgs()
	_address = _args[0]
	_port = _args[1]
	debug = _args[2]
	_gfxMode = _args[3]
else:
	ParseArgument.printHelp()
	exit()

##Init the GUI
Graphics.setGraphics(Graphics.mode[_gfxMode.lower()])
Graphics.initGraphics()

#Do TCP/IP Stuff
_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
_server_addr = (_address, _port)

if debug: print("Starting server on {}:{}.".format(*_server_addr))
_socket.bind(_server_addr)

_socket.listen(1)
_socket.settimeout(0.2)

while True:

	skip = False

	Graphics.updateGraphics()
	if debug: print("update")
	try:
		if debug: print("Waiting for client connection.")
		connection, client_address = _socket.accept()
	except:
		skip = True

	if (skip == False):
		try:
			print("Connection from " + client_address)

			while True:
				data = connection.recv(_maxpacket)
				if data:
					##TODO: Do stuff with the data.
					connection.sendall(b'RECV_OK')
				else:
					print("No data recieved from client. Restarting.")
					break
		finally:
			connection.close()