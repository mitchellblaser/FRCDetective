# FRC Detective
# Communications.py
# Created 4-2-21

import os
import socket

CustomAddress = "NULL"

def setCustomAddr(_addr):
	CustomAddress = _addr

def checkIPAddress():
	global CustomAddress
	if CustomAddress != "NULL":
		return CustomAddress
	_hostname = socket.gethostname()
	_localip = socket.gethostbyname(_hostname)
	return _localip
