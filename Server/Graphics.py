# FRC Detective
# Graphics.py
# Created 4-2-21

import GFXWindowed
import GFXLowLevel

mode = {
	"windowed" : 0,
	"lowlevel" : 1
}

def setGraphics(_mode):
	global SelectedMode

	if _mode == mode["windowed"]:
		SelectedMode = 0
	if _mode == mode["lowlevel"]:
		SelectedMode = 1

def initGraphics():
	global SelectedMode

	if SelectedMode == mode["windowed"]:
		GFXWindowed.initGraphics()
	if SelectedMode == mode["lowlevel"]:
		GFXLowLevel.initGraphics()

def updateGraphics():
	if SelectedMode == mode["windowed"]:
		GFXWindowed.updateGraphics()
	if SelectedMode == mode["lowlevel"]:
		GFXLowLevel.updateGraphics()