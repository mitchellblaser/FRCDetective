#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Max bytes to receive from any given client in one request
FRCD_MAX_PACKET_SIZE = 1024

# How many seconds to keep thread alive if we hear silence from the client
FRCD_SERVER_TIMEOUT_SECS = 20

# Detective WebSocket Port (App-Server Comms)
FRCD_SERVER_SOCKET_PORT = 5584

# Remote Web Management Port (Admin Portal)
FRCD_SERVER_MANAGEMENT_PORT = 8080