# FRC Detective
# main.py
# Created 4-2-21

_maxpacket = 1024

##Python standard libs
from socket import *
import socket
import datetime
import time
import sys
import threading
import select
import pprint

##Our custom deps
import ParseArgument
import Communications
#import Graphics 		#We need to do this later so that TK doesn't get our IP before we can set it. (ln46)
import HashScript
import FileIO
import Backup
import ParseData
import Database
import Format

backup = False

##Parse arguments from command line
if ParseArgument.isEmpty() == False:
	_args = ParseArgument.parseArgs()
	if (_args[0] == "localhost"):
		_address = Communications.checkIPAddress()
	else:
		_address = _args[0]
	_port = _args[1]
	debug = _args[2]
	_gfxMode = _args[3]
else:
	ParseArgument.printHelp()
	exit()
if _address != "localhost":
	Communications.setCustomAddr(_address)

##Init the GUI
import Graphics
Graphics.setGraphics(Graphics.mode[_gfxMode.lower()])
Graphics.initGraphics(True)

pp = pprint.PrettyPrinter(width=41, compact=True)

#Do TCP/IP Stuff
_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
_socket.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
_server_addr = (_address, _port)

print("Starting server on {}:{}.".format(*_server_addr))
_socket.bind(_server_addr)

_socket.listen(1)
_socket.settimeout(1)


Sending = False
def ThreadedSend(_data):
	global Sending
	connection.sendall(_data)

_paused = False

while True:

	if Communications.ShouldSocketClose() == True:
		try:
			connection.close()
			_socket.shutdown(1)
		except:
			break
		Graphics.CloseApplication()

	skip = False
	try:
		Graphics.updateGraphics()
	except:	##Will fail when the window no longer exists (destroy method called in GFXWindowed.py)
		exit()

	if Graphics.isPaused():
		Graphics.setStatus(Graphics.status["Paused"])
		_paused = True
		while Graphics.isPaused(): ##Need to check for exitingm while paused too.
			try:
				Graphics.updateGraphics()
			except:
				exit()
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
		skip = False
	except:
		skip = True

	if (skip == False):
		try:
			##print("Connection from " + client_address)
			Graphics.setStatus(Graphics.status["Connect"])
			while True:
				print("update")
				Graphics.updateGraphics()

				data = []

				_secs = 10
				for i in range(1, (_secs*4)):
					connection.setblocking(0)
					ready = select.select([connection], [], [], 0.25) #last param is timeout in secs
					if ready[0]:
						try:
							data = connection.recv(_maxpacket) 
						except:
							break
							break
						Graphics.setStatusString("Received Data.", "Received Data.")
						break
					Graphics.updateGraphics()

				try:
					if data:
						Graphics.updateGraphics()
						
						###	IMPORTANT: Add a check here to see if data is a "keep alive" byte	<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
						###			    because we do not want to parse it as json if it is. (so skip over the whole loop)

						global jsonuid
						global PARSEDJSON

						if data[0] == 76:
							print("Receiving Round List from Client.")
							connection.sendall(b'RECV_OK')
							time.sleep(0.5)
							print("Sending Diff.")
							Database.StoreClientDataList(ParseData.ParseRoundList(data))
							connection.sendall(ParseData.NeedsToClientBytes(Database.Difference(Database.GetKeyList(), Database.GetClientDataList())))
						elif data[0] == 82:
							print(data)
							PARSEDJSON = ParseData.Parse(data)
							jsonuid = Format.PadNumber(PARSEDJSON["Division"], 1) + "-" + Format.PadNumber(PARSEDJSON["RoundType"], 1) + "-" + Format.PadNumber(PARSEDJSON["RoundNumber"], 3) + "-" + Format.PadNumber(PARSEDJSON["TeamNumber"], 5)
							print(jsonuid)
							FileIO.AppendData("Storage.json", jsonuid, PARSEDJSON)
							connection.sendall(b'RECV_OK')
						elif data[0] == 83:
							print("Client Ready to Receive data.")
							connection.sendall(b'D')
							clientneeds = Database.Difference(Database.GetKeyList(), Database.GetClientDataList())['ClientNeeds']
							for i in range (0, len(clientneeds)):
								print("Sending to Client: " + str(clientneeds[i]))
								senddata = ParseData.ReconstructFromJson(clientneeds[i])
								connection.sendall(senddata)

						else:
							print("Unknown Code. (" + str(int(data[0])) + ")")
							print(data)

					else:
						print("No data received from client. Restarting.")
						connection.close()
						break
				except:
					print("No data received from client. Restarting.")
					connection.close()
					break
		finally:
			Graphics.setStatus(Graphics.status["Disconnect"])