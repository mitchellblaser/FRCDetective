# FRC Detective
# PluginHelper.py
# Created 29-3-21

import textwrap
import time
import os
import threading

import FileIO

_DETECTIVE_VERSION_ = 0.1

PLUGINS = []
LAST_REFRESH = {}

class API:
    def __init__(self):
        self.JSON = {}
        self.TeamList = []
        self.RoundList = []
    def Update(self):
        self.JSON = FileIO.ReadData('Storage.json')
        for entry in self.JSON:
            if entry.split("-")[3] not in self.TeamList:
                self.TeamList.append(entry.split("-")[3])
        for entry in self.JSON:
            roundString = entry.split("-")
            roundString = roundString[0] + "-" + roundString[1] + "-" + roundString[2]
            if roundString not in self.RoundList:
                self.RoundList.append(roundString)
            
# RUN ONLY FROM SERVER APPLICATION
def _Init():
    for plugin in GetPlugins():
        if GetPluginConfig(plugin)['Enabled'] == 'False':
            LAST_REFRESH[plugin] = -1
        else:
            LAST_REFRESH[plugin] = 0

# RUN ONLY FROM SERVER APPLICATION
def _EventLoop():
    for plugin in GetPlugins():
        if int(GetPluginConfig(plugin)['RunInterval']) + LAST_REFRESH[plugin] < time.time() and LAST_REFRESH[plugin] != -1:
            startThread('PLUGINS/' + plugin + "/main.py")
            LAST_REFRESH[plugin] = time.time()

def startThread(path):
    if os.name == "nt":
        ntThread = threading.Thread(target=StartNT, args=(path,))
        ntThread.start()
    else:
        otherThread = threading.Thread(target=StartOther, args=(path,))
        otherThread.start()

def StartNT(path):
    os.system("python " + str(path) + " > nul 2>&1 &")

def StartOther(path):
    #os.system("python " + str(path) + " > /dev/null 2>&1 &")
    os.system("python " + str(path))

def CheckVersion():
    return _DETECTIVE_VERSION_

def ReadConfigFile():
    f = open('PLUGINS/CONFIG.TXT', 'r')
    out = f.readlines()
    for i in range(0, len(out)):
        out[i] = out[i].rstrip()
    return out

def GetPlugins():
    global PLUGINS
    PLUGINS = []
    HEADER_INDEX = 0
    FOOTER_INDEX = 0
    ConfigFile = ReadConfigFile()
    for i in range(0, len(ConfigFile)):
        if ConfigFile[i] == "INSTALLED_PLUGINS {":
            HEADER_INDEX = i
        if ConfigFile[i] == "}" and FOOTER_INDEX == 0:
            FOOTER_INDEX = i
    for i in range(HEADER_INDEX+1, FOOTER_INDEX):
        PLUGINS.append(textwrap.dedent(ConfigFile[i]))
    return PLUGINS

def GetPluginConfig(plugin):
    ConfigFile = ReadConfigFile()
    Options = {}
    HEADER_INDEX = 0
    FOOTER_INDEX = 0
    for i in range(0, len(ConfigFile)):
        if ConfigFile[i] == "Plugin " + plugin + " {":
            HEADER_INDEX = i
        if ConfigFile[i] == "}" and FOOTER_INDEX == 0 and HEADER_INDEX != 0:
            FOOTER_INDEX = i
    for i in range(HEADER_INDEX+1, FOOTER_INDEX):
        Options[textwrap.dedent(ConfigFile[i].split(" = ")[0])] = ConfigFile[i].split(" = ")[1]
    return Options

def ValidateVersion(server_version, plugin_version, requirement_type):
    if requirement_type == '>':
        if server_version >= plugin_version:
            return True
    elif requirement_type == '<':
        if server_version <= plugin_version:
            return True
    elif requirement_type == '=':
        if server_version == plugin_version:
            return True
    return False