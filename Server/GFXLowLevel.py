# FRC Detective
# GFXLowLevel.py
# Created 4-2-21

import Graphics

def initGraphics():
	print("Low Level Graphics Initialised.")

def updateGraphics():
	x = 1

def setStatus(_status):
	status = {0: "Idle",
			  1: "Backup",
			  2: "Paused",
			  3: "Waiting",
			  4: "Connect",
			  5: "Disconnect"}

	print(str(status[_status]))