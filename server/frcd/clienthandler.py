#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Import External Libs
import select
import json

# Get Configuration Options
from configuration import *

def Handle(connection, address):
    """Main Handler Function for Client Communications.

    Args:
        connection (socket): [description]
        address ([type]): [description]
    """
    print("Accepted Connection from Client at " + str(address) + ".")
    connected = True
    while connected:
        connection.setblocking(True)
        ready = select.select([connection], [], [], FRCD_SERVER_TIMEOUT_SECS)
        if ready[0]:
            data = connection.recv(FRCD_MAX_PACKET_SIZE)
            # {
            #   "request": "type"
            #   "from":    [user, password(encrypted)]
            #   "data":    {}
            # }

            print(data)
            StateMachine(json.loads(data))

        else:
            connected = False
    return


def StateMachine(parsed_json):
    if parsed_json["request"] == "GET_DIFF":
        GetDiff(parsed_json)
    elif parsed_json["request"] == "GET_TEAM":
        GetTeam(parsed_json)
    elif parsed_json["request"] == "GET_MATCH":
        GetMatch(parsed_json)
    elif parsed_json["request"] == "GET_CHUNK":
        GetChunk(parsed_json)
    elif parsed_json["request"] == "PUT_TEAM":
        PutTeam(parsed_json)
    elif parsed_json["request"] == "PUT_MATCH":
        PutMatch(parsed_json)
    elif parsed_json["request"] == "PUT_CHUNK":
        PutChunk(parsed_json)
    return


def GetDiff(parsed_json):
    return


def GetTeam(parsed_json):
    return


def GetMatch(parsed_json):
    return


def GetChunk(parsed_json):
    return


def PutTeam(parsed_json):
    return


def PutMatch(parsed_json):
    return


def PutChunk(parsed_json):
    return


