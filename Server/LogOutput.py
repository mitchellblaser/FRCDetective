# FRC Detective
# LogOutput.py
# Created 5-2-21

import datetime

import Graphics
import FileIO


loggedPause = False

def OutputCode(_logcode):
	global loggedPause
	_output = ""

	timestamp = datetime.datetime.now()
	timestring = "0"*int(2-len(str(timestamp.hour))) + str(timestamp.hour) + ":" + \
				 "0"*int(2-len(str(timestamp.minute))) + str(timestamp.minute) + ":" + \
				 "0"*int(2-len(str(timestamp.second))) + str(timestamp.second)

	if _logcode == Graphics.status["Backup"]:
		_output = timestring + " -> " + "Backup in progress.\n"
	if _logcode == Graphics.status["Paused"]:
		_output = timestring + " -> " + "Server processing temporarily paused.\n"
		loggedPause = True
	if _logcode == Graphics.status["Idle"] and loggedPause == True:
		_output = timestring + " -> " + "Server resumed operation.\n"
		loggedPause = False

	if _output != "":
		#FileIO.AppendData("CurrentLog.txt", _output)


def DirectOutput(_output):
	#FileIO.AppendData("CurrentLog.txt", _output)
	return