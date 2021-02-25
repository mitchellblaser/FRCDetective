# FRC Detective
# Communications.py
# Created 4-2-21

import os
import socket

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