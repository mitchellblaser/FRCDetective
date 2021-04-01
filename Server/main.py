# FRC Detective
# main.py
# Created 4-2-21

########################[ Paremeters - Leave as is. ]######################
_maxpacket = 1024
_timeoutSecs = 1000

#TODO: SET VERSION IN PluginHelper.py AFTER MAJOR RELEASE UPDATE!


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
import PluginHelper


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
	exit()


##########################[ Initialize Graphics ]##########################
Graphics.setGraphics(Graphics.mode[_gfxMode.lower()]) #Pass value from command if there is one (defaults to web)
Graphics.initGraphics()


###########################[ Initialize Plugins ]##########################
PluginHelper._Init()
pluginHelper = threading.Thread(target=PluginHelper._EventLoop, args=())
pluginHelper.start()

##########################[ Setup TCP/IP Socket ]##########################
_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #Make our instance
_socket.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1) #Set to reuse addresses.
#_socket.setsockopt(SOL_SOCKET, SO_REUSEPORT, 1) #Set to reuse ports.
_server_addr = (_address, _port) #We get these values when we parse arguments.
Graphics.setStatusString("NET", "Starting Server on {}:{}.".format(*_server_addr))
_socket.bind(_server_addr)
_socket.listen(1)


#######################[ Start Command Processor ]########################
CommandProcessor = threading.Thread(target=Communications.ProcessCommands, args=())
CommandProcessor.start()


###########################[ Main Server Loop ]###########################
while Communications.ShouldSocketClose() == False:

	######################[ Accept Connections ]##########################
	connection, address = _socket.accept()
	ServerThread = threading.Thread(target=Communications.ClientHandler, args=(connection, address, _timeoutSecs, _maxpacket))
	ServerThread.start()

###########################[ Post-Loop Cleanup ]##########################
try:
	_socket.shutdown(1)
finally:
	sys.exit()
