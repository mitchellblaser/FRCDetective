# FRC Detective
# GFXWindowed.py
# Created 4-2-21

from tkinter import *
from PIL import Image, ImageTk
import sys
import datetime

import Communications
import Graphics

def cmdTest():
	print("TEST <<<<<<<")
def cmdExit():
	setStatusString("Exit Scheduled.", "Application scheduled to close.")
	Communications.scheduleSocketClose(True)
def cmdPause():
	global paused
	if paused == True:
		setStatus(Graphics.status["Idle"])
		btnPause.configure(text="Pause")
		paused = False
	else:
		setStatus(Graphics.status["Paused"])
		btnPause.configure(text="Resume")
		paused = True

def CloseApplication():
	window.destroy()

paused = False
_justPaused = False
_lastWait = False

window = Tk()
window.geometry("400x790")
window.title("FRC Detective Server")
window.configure(bg="gray8")

##Logo
imgLogo = Image.open("logo.png")
imgrLogo = ImageTk.PhotoImage(imgLogo)
imglLogo = Label(window, image=imgrLogo, bg="gray8")
imglLogo.pack(pady=(20, 0))

##Titles
lblTitle = Label(window, text="FRC Detective", font=("Arial Bold", 50), fg="white", bg="gray8")
lblTitle.pack()
lblSubtitle = Label(window, text="Server Version 1.0", font=("Arial", 28), fg="white", bg="gray8")
lblSubtitle.pack(pady=(0,60))

##Connected IP
lblIP = Label(window, text="Server IP: " + Communications.checkIPAddress(), font=("Arial", 14), fg="white", bg="gray8")
lblIP.pack()

##Status
lblStatus = Label(window, text="Server Status: " + "Idle.", font=("Arial", 14), fg="white", bg="gray8")
lblStatus.pack(pady=(0,60))


##Server Log
lblServerLog = Label(window, text="Server Log", font=("Arial", 14), fg="white", bg="gray8")
lblServerLog.pack()
txtServerLog = Text(window, bd=0, bg="grey12", fg="white", highlightbackground="gray8")
txtServerLog.pack(fill="y", expand=True)

##Buttons
frmButtons = Frame(window)
frmButtons.pack(fill="x", expand=True)

btnSave = Button(frmButtons, text="Save", command=cmdTest, bg="gray8")
btnSave.pack(side="left", fill="both", expand=True)
btnPause = Button(frmButtons, text="Pause", command=cmdPause, bg="gray8")
btnPause.pack(side="left", fill="both", expand=True)
btnExit = Button(frmButtons, text="Exit", command=cmdExit, bg="gray8")
btnExit.pack(side="right", fill="both", expand=True)

def initGraphics():
	window.update_idletasks()
	window.update()
	print("Windowed Graphics Initialised.")

def updateGraphics():
	window.update_idletasks()
	window.update()

def isPaused():
	return paused

def setStatus(_status):
	global _justPaused
	global _lastWait
	_ss = "Server Status: "
	timestamp = datetime.datetime.now()
	timestring = "0"*int(2-len(str(timestamp.hour))) + str(timestamp.hour) + ":" + \
				 "0"*int(2-len(str(timestamp.minute))) + str(timestamp.minute) + ":" + \
				 "0"*int(2-len(str(timestamp.second))) + str(timestamp.second)

	if _status == Graphics.status["Backup"]:
		lblStatus.configure(text=_ss + "Backing Up.")
		txtServerLog.insert(INSERT, "\n" + timestring + " -> Backing up now.")
		txtServerLog.see(END)
	if _status == Graphics.status["Idle"]:
		lblStatus.configure(text=_ss + "Idle.")
		if _justPaused == True:
			txtServerLog.insert(INSERT, "\n" + timestring + " -> Server Execution Resumed.")
			txtServerLog.see(END)
			_justPaused = False
	if _status == Graphics.status["Paused"]:
		if _justPaused == False:
			lblStatus.configure(text=_ss + "Execution Paused.")
			txtServerLog.insert(INSERT, "\n" + timestring + " -> Server Execution temporarily Paused.")
			txtServerLog.see(END)
			_lastWait = False
			_justPaused = True
	if _status == Graphics.status["Waiting"]:
		if (_lastWait==False):
			_lastWait = True
			lblStatus.configure(text=_ss + "Waiting for Connection.")
			txtServerLog.insert(INSERT, "\n" + timestring + " -> Waiting for connection (polling every 0.2s)")
			txtServerLog.see(END)
	if _status == Graphics.status["Connect"]:
		lblStatus.configure(text=_ss + "Client Connected.")
		txtServerLog.insert(INSERT, "\n" + timestring + " -> Client Connected.")
		txtServerLog.see(END)
	if _status == Graphics.status["Disconnect"]:
		lblStatus.configure(text=_ss + "Client Disconnected.")
		txtServerLog.insert(INSERT, "\n" + timestring + " -> Client Disconnected.")
		txtServerLog.see(END)

def setStatusString(_statusTitle, _statusMessage):
	_ss = "Server Status: "
	timestamp = datetime.datetime.now()
	timestring = "0"*int(2-len(str(timestamp.hour))) + str(timestamp.hour) + ":" + \
				 "0"*int(2-len(str(timestamp.minute))) + str(timestamp.minute) + ":" + \
				 "0"*int(2-len(str(timestamp.second))) + str(timestamp.second)
	lblStatus.configure(text=_ss + _statusTitle)
	txtServerLog.insert(INSERT, "\n" + timestring + " " + _statusMessage)
	txtServerLog.see(END)

