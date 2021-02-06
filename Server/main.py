# FRC Detective
# main.py
# Created 4-2-21

_maxpacket = 1024

##Python standard libs
import socket
import datetime
import sys
import threading
import select

##Our custom deps
import ParseArgument
import Graphics
import HashScript
import Communications
import FileIO
import Backup
import ParseData

backup = False

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

print("Starting server on {}:{}.".format(*_server_addr))
_socket.bind(_server_addr)

_socket.listen(1)
_socket.settimeout(1)


Sending = False
def ThreadedSend():
	global Sending
	connection.sendall(b'RECV_OK')

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
		if not Sending:
			Graphics.setStatus(Graphics.status["Idle"])
			Sending = True
	try:
		Graphics.setStatus(Graphics.status["Waiting"])
		connection, client_address = _socket.accept()
	except:
		skip = True

	if (skip == False):
		try:
			##print("Connection from " + client_address)
			Graphics.setStatus(Graphics.status["Connect"])
			while True:
				print("update")
				Graphics.updateGraphics()

				_secs = 10
				for i in range(1, (_secs*4)):
					connection.setblocking(0)
					ready = select.select([connection], [], [], 0.25) #last param is timeout in secs
					if ready[0]:
						data = connection.recv(_maxpacket) 
						Graphics.setStatusString("Recieved Data." "Recieved Data.")
						break
					Graphics.updateGraphics()


				try:
					if data:
						Graphics.updateGraphics()
						ParseData.Parse(data)
						threadedSend = threading.Thread(target=ThreadedSend, args=())
						threadedSend.start()
					else:
						print("No data recieved from client. Restarting.")
						break
				except:
					print("No data recieved from client. Restarting.")
					break
		finally:
			Graphics.setStatus(Graphics.status["Disconnect"])
			connection.close()