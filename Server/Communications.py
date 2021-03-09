# FRC Detective
# Communications.py
# Created 4-2-21

import os
import socket
import select
import time
import sys
import threading

import Graphics
import Format
import Database
import ParseData
import FileIO

CustomAddress = "NULL"
SocketShouldClose = False

def setCustomAddr(_addr):
	global CustomAddress
	CustomAddress = _addr

def checkIPAddress():
	global CustomAddress
	if CustomAddress != "NULL":
		return CustomAddress
	_hostname = socket.gethostname()
	_localip = socket.gethostbyname(_hostname)
	return _localip

def scheduleSocketClose(_state):
	global SocketShouldClose
	SocketShouldClose = _state

def ShouldSocketClose():
	global SocketShouldClose
	return SocketShouldClose

#########[ Load list of Admin Users from ./webgui/adminusers.txt ]#########
def GetAdmins(): #Define this as a function - we use it again later.
	global admins
	admins = []
	adminlist = open("webgui/adminusers.txt", "r")
	for user in adminlist:
		admins.append(user.rstrip())

def ProcessCommands():
	while True:
		#################[ Validate Web Server Commands ]##################
		_COMMAND = Graphics.GetCommand() #Will return [command, userid, email]
		GetAdmins()
		if Graphics.ValidateCommand(_COMMAND, admins):
			##############[ Process Web Server Commands ]#####################
			if _COMMAND[0] == "STOP":
				scheduleSocketClose(True) #Safely close sockets and quit server
				Graphics.setStatusString("CMD", "User " + _COMMAND[1] + " has stopped the server.")
				os._exit(1)


def ClientHandler(connection, address, timeoutSecs, maxPacket):
	Graphics.setStatusString("NET", "Connection from " + str(address) + ".")
	lock = threading.Lock()
	_connected = True
	_clientDataList = []
	while _connected:
		data = []
		for i in range(1, (timeoutSecs*4)):
			connection.setblocking(1)
			ready = select.select([connection], [], [], 0.25) #Timeout in seconds - Multiplied by 4 in loop range() function.
			if ready[0]:
				try:
					data = connection.recv(maxPacket)
					break
				except Exception as e:
					print(e)
					_connected = False
					break
		### Make sure we've got actual data before using it
		### Kill the thread if the client's gone, or if it hasn't sent anything
		if not ready[0]:
			_connected = False
		try:
			data[0]
		except:
			_connected = False

		if data:
			Format.PrintHex(data)
			# RECIEVE ROUND LIST #
			if data[0] == 76:
				connection.sendall(b'RECV_OK')
				time.sleep(0.1)
				_clientDataList = ParseData.ParseRoundList(data)
				lock.acquire()
				connection.sendall(ParseData.NeedsToClientBytes(Database.Difference(Database.GetKeyList(), _clientDataList)))
				lock.release()

			# ENTER ROUND LOOP #
			elif data[0] == 82:
				_receiveRound = True
				connection.sendall(b'RECV_OK')
				while _receiveRound == True:
					_round = connection.recv(maxPacket)
					_parsedRound = ParseData.Parse(_round)
					_jsonuid = Format.PadNumber(_parsedRound["Division"], 1) + "-" + Format.PadNumber(_parsedRound["RoundType"], 1) + "-" + Format.PadNumber(_parsedRound["RoundNumber"], 3) + "-" + Format.PadNumber(_parsedRound["TeamNumber"], 5)
					lock.acquire()
					FileIO.AppendData("Storage.json", _jsonuid, _parsedRound)
					lock.release()
					connection.sendall(b'RECV_OK')
					if _round[40] == 0:
						_receiveRound = False

			# CLIENT READY TO RECEIVE #
			elif data[0] == 83:				
				# Generate Diff
				lock.acquire()
				_clientneeds = Database.Difference(Database.GetKeyList(), _clientDataList)['ClientNeeds']
				lock.release()

				# Only send the [D]ata if we do not have [Z]ero data to send.
				if len(_clientneeds) == 0:
					connection.sendall(b"Z")
				else:
					connection.sendall(b"D")
				
				# Iterate through rounds to send
				_end = 1
				for i in range(0, len(_clientneeds)):
					if i == len(_clientneeds)-1:
						_end = 0
					lock.acquire()
					connection.sendall(ParseData.ReconstructFromJson(_clientneeds[i], _end))
					lock.release()
					_resp = connection.recv(maxPacket)
					if _resp != b'RECV_OK':
						Graphics.setStatusString("ERR", "Client did not reply. Killing Thread.")
						_connected = False
						break

			# UNKNOWN #
			else:
				Graphics.setStatusString("ERR", "Received Unknown Command from Client " + str(address) + ".")
	Graphics.setStatusString("NET", "Closing Connection from " + str(address) + ".")
	connection.close()