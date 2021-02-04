# FRC Detective
# GFXWindowed.py
# Created 4-2-21

from tkinter import *

import Communications

def cmdTest():
	print("TEST <<<<<<<")
def cmdExit():
	print("Exiting.")

_statusMsg = "Idle."

window = Tk()
window.geometry("400x720")
window.title("FRC Detective Server")

##Titles
lblTitle = Label(window, text="FRC Detective", font=("Arial Bold", 50))
lblTitle.pack(pady=(20, 0))
lblSubtitle = Label(window, text="Server Version 1.0", font=("Arial", 28))
lblSubtitle.pack(pady=(0,60))

##Connected IP
lblIP = Label(window, text="Server IP: " + Communications.checkIPAddress(), font=("Arial", 14))
lblIP.pack()

##Status
lblStatus = Label(window, text="Server Status: " + _statusMsg, font=("Arial", 14))
lblStatus.pack(pady=(0,60))


##Server Log
lblServerLog = Label(window, text="Server Log", font=("Arial", 14))
lblServerLog.pack()
txtServerLog = Text(window, bd=0, bg="grey90")
txtServerLog.pack(fill="y", expand=True)

##Buttons
frmButtons = Frame(window)
frmButtons.pack(fill="x", expand=True)

btnSave = Button(frmButtons, text="Save", command=cmdTest)
btnSave.pack(side="left", fill="x", expand=True)
btnExit = Button(frmButtons, text="Exit", command=cmdExit)
btnExit.pack(side="right", fill="x", expand=True)

def initGraphics():
	window.update_idletasks()
	window.update()
	print("Windowed Graphics Initialised.")

def updateGraphics():
	window.update_idletasks()
	window.update()

