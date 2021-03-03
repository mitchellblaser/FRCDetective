# FRC Detective
# GFXLowLevel.py
# Created 4-2-21

import Graphics

printStatus = True

def initGraphics():
	print("Low Level Graphics Initialised.")

def updateGraphics():
	x = 1

def setStatus(_status):
	global printStatus

	status = {0: "Idle",
			  1: "Backup",
			  2: "Paused",
			  3: "Waiting",
			  4: "Connect",
			  5: "Disconnect"}

	if _status == 3:
		if printStatus == True:
			print(str(status[_status]))
			printStatus = False
	else:
		printStatus = True
		print(str(status[_status]))