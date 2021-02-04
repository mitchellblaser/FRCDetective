# FRC Detective
# ParseArgument.py
# Created 4-2-21

import sys

def printHelp():
	helpfile = open("HELPFILE", "r")
	print(helpfile.read())


def parseArgs():

	_len = len(sys.argv)

	_a = ""
	_p = 0000
	_d = False

	for i in range (0, _len):
		if sys.argv[i]=="-a" or sys.argv[i]=="--address":
			_a = sys.argv[i+1]
		if sys.argv[i]=="-p" or sys.argv[i]=="--port":
			_p = int(sys.argv[i+1])
		if sys.argv[i]=="-d" or sys.argv[i]=="--debug":
			_d = bool(sys.argv[i+1])

	return [_a, _p, _d]