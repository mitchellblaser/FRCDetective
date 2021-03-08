# FRC Detective
# Graphics.py
# Created 4-2-21

import GFXLowLevel
import GFXWeb

mode = {
	"windowed" : 0,
	"lowlevel" : 1,
	"web"	   : 2
}

status = {
	"Idle"       : 0,
	"Backup"     : 1,
	"Paused"     : 2,
	"Waiting"    : 3,
	"Connect"    : 4,
	"Disconnect" : 5
}

def setGraphics(_mode):
	global SelectedMode

	if _mode == mode["windowed"]:
		SelectedMode = 0
	if _mode == mode["lowlevel"]:
		SelectedMode = 1
	if _mode == mode["web"]:
		SelectedMode = 2

def initGraphics():
	global SelectedMode

	if SelectedMode == mode["lowlevel"]:
		GFXLowLevel.initGraphics()
	if SelectedMode == mode["web"]:
		GFXWeb.initGraphics()

def updateGraphics():
	if SelectedMode == mode["lowlevel"]:
		GFXLowLevel.updateGraphics()

def setStatus(_status):
	if SelectedMode == mode["web"]:
		GFXWeb.setStatus(_status)
	if SelectedMode == mode["lowlevel"]:
		GFXLowLevel.setStatus(_status)

def setStatusString(_statusTitle, _statusMessage):
	if SelectedMode == mode["web"]:
		GFXWeb.setStatusString(_statusTitle, _statusMessage)
	if SelectedMode == mode["lowlevel"]:
		GFXLowLevel.setStatusString(_statusTitle, _statusMessage)

def isPaused():
	if SelectedMode == mode["lowlevel"]:
		return False

def GetCommand():
	global SelectedMode
	if SelectedMode == mode["web"]:
		return GFXWeb.GetCommand()
	else:
		return ""

def ValidateCommand(_COMMAND, _ADMINS):
	if _COMMAND != []:
		if _COMMAND[1] in _ADMINS:
			return True
	return False