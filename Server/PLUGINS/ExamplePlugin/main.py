# Plugin Metadata #
_PLUGIN_            = 'ExamplePlugin'
_DETECTIVE_VERSION_ = 0.1
_VERSION_RULES_     = '>' #OPTIONS: '>', '<', '='
_AUTHOR_            = 'github.com/mitchellblaser'
_DESCRIPTION_       = "Copy this folder and use it to create plugins of your own."

# Standard Library Imports #
import os
import sys
from datetime import datetime

# Custom FRCDetective Imports #
IMPORTPATH = os.getcwd().split("/PLUGINS/"+_PLUGIN_)[0]
sys.path.append(IMPORTPATH)
import PluginHelper

# Open Log File #
LOGPATH = 'PLUGINS/' + _PLUGIN_ + '/log.txt'
logfile = open(LOGPATH, 'w')
def WriteLog(input_str):
    logfile.write(str(input_str) + "\n")

# Compatibility Check #
WriteLog(_PLUGIN_ + " - Target Version : " + str(_VERSION_RULES_) + str(_DETECTIVE_VERSION_))
WriteLog("Execution Initialized at " + datetime.now().strftime("%Y/%m/%d %H:%M:%S"))
if PluginHelper.ValidateVersion(PluginHelper.CheckVersion(), _DETECTIVE_VERSION_, _VERSION_RULES_) is not True:
    WriteLog("Version Validation did not pass!")
    sys.exit()

# Create Instance of API and Update it's data #
API = PluginHelper.API()
API.Update()

# Plugin Code Here #
WriteLog(API.TeamList)
WriteLog(API.RoundList)

# Plugin Exit Point #
sys.exit()