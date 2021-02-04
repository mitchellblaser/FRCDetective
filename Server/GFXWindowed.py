# FRC Detective
# GFXWindowed.py
# Created 4-2-21

from tkinter import *
from PIL import Image, ImageTk

import Communications

def cmdTest():
	print("TEST <<<<<<<")
def cmdExit():
	print("Exiting.")

_statusMsg = "Idle."

window = Tk()
window.geometry("400x790")
window.title("FRC Detective Server")
window.configure(bg="gray97")

##Logo
imgLogo = Image.open("logo.png")
imgrLogo = ImageTk.PhotoImage(imgLogo)
imglLogo = Label(window, image=imgrLogo, bg="gray97")
imglLogo.pack(pady=(20, 0))

##Titles
lblTitle = Label(window, text="FRC Detective", font=("Arial Bold", 50), bg="gray97")
lblTitle.pack()
lblSubtitle = Label(window, text="Server Version 1.0", font=("Arial", 28), bg="gray97")
lblSubtitle.pack(pady=(0,60))

##Connected IP
lblIP = Label(window, text="Server IP: " + Communications.checkIPAddress(), font=("Arial", 14), bg="gray97")
lblIP.pack()

##Status
lblStatus = Label(window, text="Server Status: " + _statusMsg, font=("Arial", 14), bg="gray97")
lblStatus.pack(pady=(0,60))


##Server Log
lblServerLog = Label(window, text="Server Log", font=("Arial", 14), bg="gray97")
lblServerLog.pack()
txtServerLog = Text(window, bd=0, bg="grey90", highlightbackground="gray97")
txtServerLog.pack(fill="y", expand=True)

##Buttons
frmButtons = Frame(window)
frmButtons.pack(fill="x", expand=True)

btnSave = Button(frmButtons, text="Save", command=cmdTest)
btnSave.pack(side="left", fill="both", expand=True)
btnExit = Button(frmButtons, text="Exit", command=cmdExit)
btnExit.pack(side="right", fill="both", expand=True)

def initGraphics():
	window.update_idletasks()
	window.update()
	print("Windowed Graphics Initialised.")

def updateGraphics():
	window.update_idletasks()
	window.update()

