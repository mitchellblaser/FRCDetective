# FRC Detective
# GFXWindowed.py
# Created 4-2-21

from tkinter import *

import Communications

def cmdTest():
	print("TEST <<<<<<<")

_statusMsg = "Idle."

window = Tk()
window.geometry("400x680")
window.title("FRC Detective Server")

##Titles
lblTitle = Label(window, text="FRC Detective", font=("Arial Bold", 50))
lblTitle.pack(pady=(20, 0))
lblSubtitle = Label(window, text="Server Version 1.", font=("Arial", 28))
lblSubtitle.pack(pady=(0,60))

##Connected IP
lblIP = Label(window, text="Server IP: " + Communications.checkIPAddress(), font=("Arial", 14))
lblIP.pack()

##Status
lblStatus = Label(window, text="Server Status: " + _statusMsg, font=("Arial", 14))
lblStatus.pack(pady=(0,60))


##Server Log
lblServerLog = Label(window, text="Server Log", font=("Arial", 14))
lblServerLog.pack(padx=(0,310))
txtServerLog = Text(window, bd=0, bg="grey90")
txtServerLog.pack(fill="both")

##Test Button
btnTest = Button(window, text="Test", command=cmdTest)

def initGraphics():
	window.update_idletasks()
	window.update()
	print("Windowed Graphics Initialised.")

def updateGraphics():
	window.update_idletasks()
	window.update()

