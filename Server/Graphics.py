# FRC Detective
# Graphics.py
# Created 4-2-21

import GFXWindowed
import GFXLowLevel
import LogOutput

mode = {
	"windowed" : 0,
	"lowlevel" : 1
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

def initGraphics(_log):
	global SelectedMode
	global DoLogOutput

	if _log:
		DoLogOutput = True
	else:
		DoLogOutput = False

	if SelectedMode == mode["windowed"]:
		GFXWindowed.initGraphics()
	if SelectedMode == mode["lowlevel"]:
		GFXLowLevel.initGraphics()

def updateGraphics():
	if SelectedMode == mode["windowed"]:
		GFXWindowed.updateGraphics()
	if SelectedMode == mode["lowlevel"]:
		GFXLowLevel.updateGraphics()

def setStatus(_status):
	if SelectedMode == mode["windowed"]:
		GFXWindowed.setStatus(_status)
	if SelectedMode == mode["lowlevel"]:
		GFXLowLevel.setStatus(_status)
	if DoLogOutput == True:
		LogOutput.OutputCode(_status)

def setStatusString(_statusTitle, _statusMessage):
	if SelectedMode == mode["windowed"]:
		GFXWindowed.setStatusString(_statusTitle, _statusMessage)

def isPaused():
	if SelectedMode == mode["windowed"]:
		return GFXWindowed.isPaused()
	if SelectedMode == mode["lowlevel"]:
		print("Pause operation not supported on non-windowed application.")