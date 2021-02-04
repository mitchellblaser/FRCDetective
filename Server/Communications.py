# FRC Detective
# Communications.py
# Created 4-2-21

import os
import socket

def checkIPAddress():
	_hostname = socket.gethostname()
	_localip = socket.gethostbyname(_hostname)
	return _localip
