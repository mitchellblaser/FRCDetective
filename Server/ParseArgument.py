# FRC Detective
# ParseArgument.py
# Created 4-2-21

import sys

def printHelp():
	helpfile = open("HELPFILE", "r")
	print(helpfile.read())

def isEmpty():
	if len(sys.argv) < 2:
		return True
	else:
		return False

def parseArgs():

	_len = len(sys.argv)

	##Set defaults here
	_a = "localhost"
	_p = 0000
	_d = False
	_g = "windowed"

	for i in range (0, _len):
		if sys.argv[i]=="-a" or sys.argv[i]=="--address":
			_a = sys.argv[i+1]
		if sys.argv[i]=="-p" or sys.argv[i]=="--port":
			_p = int(sys.argv[i+1])
		if sys.argv[i]=="-d" or sys.argv[i]=="--debug":
			_d = bool(sys.argv[i+1])
		if sys.argv[i]=="-g" or sys.argv[i]=="--graphics":
			_g = sys.argv[i+1]

	return [_a, _p, _d, _g]