# FRC Detective
# main.py
# Created 4-2-21

########################[ Paremeters - Leave as is. ]######################
_maxpacket = 1024
_timeoutSecs = 10


###########################[ External Libraries ]##########################
from socket import *
import socket
import datetime
import time
import sys
import threading
import select
import pprint
import os

#############################[ Internal Files ]############################
import ParseArgument
import Communications
import Graphics
import HashScript
import FileIO
import Backup
import ParseData
import Database
import Format


###################[ Parse Arguments from Command Line ]###################
if ParseArgument.isEmpty() == False:
	_args = ParseArgument.parseArgs()

	_port = _args[1]
	_debug = _args[2]
	_gfxMode = _args[3]

	# Check if we're using localhost, or a custom address
	if _args[0] == "localhost":
		_address = Communications.checkIPAddress()
	else:
		_address = _args[0]
else:
	ParseArgument.printHelp()

#########[ Load list of Admin Users from ./webgui/adminusers.txt ]#########
def GetAdmins(): #Define this as a function - we use it again later.
	global admins
	admins = []
	adminlist = open("webgui/adminusers.txt", "r")
	for user in adminlist:
		admins.append(user.rstrip())
GetAdmins() #Call the function.


##########################[ Initialize Graphics ]##########################
Graphics.setGraphics(Graphics.mode[_gfxMode.lower()]) #Pass value from command if there is one (defaults to web)
Graphics.initGraphics()


##########################[ Setup TCP/IP Socket ]##########################
_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #Make our instance
_socket.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1) #Set to reuse addresses.
#_socket.setsockopt(SOL_SOCKET, SO_REUSEPORT, 1) #Set to reuse ports.
_server_addr = (_address, _port) #We get these values when we parse arguments.
Graphics.setStatusString("NET", "Starting Server on {}:{}.".format(*_server_addr))
_socket.bind(_server_addr)
_socket.listen(1)


###########################[ Main Server Loop ]###########################
while Communications.ShouldSocketClose() == False:

	# note: might need to thread this? only runs every time a client disconnects.
	#################[ Validate Web Server Commands ]#####################
	_COMMAND = Graphics.GetCommand() #Will return [command, userid, email]
	GetAdmins()
	if Graphics.ValidateCommand(_COMMAND, admins):
		##############[ Process Web Server Commands ]#####################
		if _COMMAND[0] == "STOP":
			Communications.scheduleSocketClose(True) #Safely close sockets and quit server
			Graphics.setStatusString("CMD", "User " + _COMMAND[1] + "has stopped the server.")
		elif _COMMAND[0] == "PAUSE":
			while True: #Hold here until command is "RESUME"
				time.sleep(0.2) #Save processing time and file IO
				_SUBCOMMAND = Graphics.GetCommand()
				GetAdmins()
				if Graphics.ValidateCommand(_SUBCOMMAND, admins):
					if _COMMAND[0] == "RESUME":
						break #out of loop, which halts execution.


	######################[ Accept Connections ]##########################
	connection, address = _socket.accept()
	ServerThread = threading.Thread(target=Communications.ClientHandler, args=(connection, address, _timeoutSecs, _maxpacket))
	ServerThread.start()

###########################[ Post-Loop Cleanup ]##########################
try:
	_socket.shutdown(1)
finally:
	exit()