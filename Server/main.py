# FRC Detective
# main.py
# Created 4-2-21

_maxpacket = 1024

##Python standard libs
import socket
import datetime

##Our custom deps
import ParseArgument
import Graphics
import HashScript
import Communications
import FileIO
import Backup

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
Graphics.initGraphics(True)

#Do TCP/IP Stuff
_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
_server_addr = (_address, _port)

if debug: print("Starting server on {}:{}.".format(*_server_addr))
_socket.bind(_server_addr)

_socket.listen(1)
_socket.settimeout(0.2)

_paused = False

while True:
	skip = False
	try:
		Graphics.updateGraphics()
	except:	##Will fail when the window no longer exists (destroy method called in GFXWindowed.py)
		exit()

	if Graphics.isPaused():
		Graphics.setStatus(Graphics.status["Paused"])
		_paused = True
		while Graphics.isPaused():
			Graphics.updateGraphics()
	if _paused:
		Graphics.setStatus(Graphics.status["Idle"])
		_paused = False

	timestamp = datetime.datetime.now()
	if (timestamp.second) == 29:
		backup = True
	if (timestamp.second == 30 and backup == True):
		backup = False
		Graphics.setStatus(Graphics.status["Backup"])
		Graphics.updateGraphics()
		Backup.Start()
		Graphics.setStatus(Graphics.status["Idle"])


	if debug: print("display update")
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