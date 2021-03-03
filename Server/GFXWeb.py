# FRC Detective
# GFXWeb.py
# Created 3-3-21

import os
import threading
import time
import datetime

sendWaiting = True
justCleared = False

def initGraphics():
    ClearLog()
    if os.name == "nt":
        print("Web Server Starting under Windows")
        ntWebThread = threading.Thread(target=StartNT)
        ntWebThread.start()
    else:
        print("Web Server Starting under Bash")
        otherWebThread = threading.Thread(target=StartOther)
        otherWebThread.start()

def StartNT():
    os.system("python ./webgui/webgui.py > nul 2>&1 &")

def StartOther():
    os.system("python ./webgui/webgui.py > /dev/null 2>&1 &")

def ClearLog():
    global justCleared
    statusfile = open("./webgui/logfile.txt", "w")
    statusfile.write("")
    statusfile.close()
    justCleared = True

def WriteLog(_status):
    global justCleared
    print("Log: " + _status)
    statusfile = open("./webgui/logfile.txt", "a")
    ts = time.time()
    timestamp = datetime.datetime.fromtimestamp(ts).strftime('%H:%M:%S')
    if justCleared == True:
        justCleared = False
        statusfile.write(str(timestamp) + ": " + str(_status))
    else:
        statusfile.write("\n" + str(timestamp) + ": " + str(_status))
    statusfile.close()

def setStatus(_status):
    global sendWaiting
    status = {
        0: "Server Idle.",
        1: "Backing up now.",
        2: "Server Execution Paused!",
        3: "Waiting for Connection...",
        4: "Client Connected.",
        5: "Client Disconnected."
    }
    if _status == 3:
        if sendWaiting == True:
            WriteLog(status[_status])
            sendWaiting = False
    else:
        sendWaiting = True
        WriteLog(status[_status])

def setStatusString(_statusTitle, _statusMessage):
	WriteLog(_statusMessage)

def ClearCmdFile():
    cmdfile = open("./webgui/cmdfile.txt", "w")
    cmdfile.write("")
    cmdfile.close()

def GetCommand():
    cmdfile = open("./webgui/cmdfile.txt", "r")
    contents = cmdfile.read()
    cmdfile.close()
    ClearCmdFile()
    return contents