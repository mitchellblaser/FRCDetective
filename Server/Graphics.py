# FRC Detective
# Graphics.py
# Created 4-2-21

import GFXLowLevel
import GFXWindowed

mode = {
	"windowed" : 0,
	"lowlevel" : 1
}

def setGraphics(_mode):
	if _mode == mode["windowed"]:
		GFXWindowed.initGraphics()
	if _mode == mode["lowlevel"]:
		GFXLowLevel.initGraphics()