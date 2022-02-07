#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Import External Libs
import threading
import os
import sys

# Get Configuration Options
from configuration import *

# Import Internal Python Files
import frcd.motd
import frcd.management
import frcd.network
import frcd.clienthandler

# Throw debug messages to command line buffer
print(frcd.motd.msg)

# Read User-Defined Configuration File
frcd.management.init(not os.path.exists(".frcdserver.conf"))

# Begin Management Interface Web Server
management_thread = threading.Thread(
    target=frcd.management.serve,
    args=(FRCD_SERVER_MANAGEMENT_PORT,)
)
management_thread.setDaemon(True)
management_thread.start()

# Setup TCP/IP Socket
main_sock = frcd.network.ConfigureMainSocket()

# Main Server Loop
# (This is executed once per connection request)
server_should_run_loop = True
while server_should_run_loop:
    try:
        _connection, _address = main_sock.accept()
    except KeyboardInterrupt:
        print("")
        print("Detected Keyboard Interrupt. Cleanly Exiting...")
        server_should_run_loop = False
    
    if server_should_run_loop:
        server_thread = threading.Thread(
            target=frcd.clienthandler.Handle,
            args=(_connection, _address)
        )
        server_thread.start()

# Application Cleanup on-exit
main_sock.close()
sys.exit()