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
import time
import socket

# Get Configuration Options
from configuration import *

# Import Internal Python Files
import frcd.fileman
from frcd.fileman import FileTypes

def Handle(connection : socket.socket, address : tuple) -> None:
    """Main Handler Function for Client Communications.

    Args:
        connection (socket): [description]
        address ([type]): [description]
    """
    global _connection
    print("Accepted Connection from Client at " + str(address) + ".")
    connected = True
    while connected:
        connection.setblocking(True)
        ready = select.select([connection], [], [], FRCD_SERVER_TIMEOUT_SECS)
        if ready[0]:
            data = connection.recv(FRCD_MAX_PACKET_SIZE)
            if data != b'':
                # {
                #   "request": "type"
                #   "from":    [user, password(encrypted)]
                #   "data":    {}
                # }

                parsed_json = json.loads(data)
                parsed_json["data"]["epoch_since_receive"] = time.time()

                _connection = connection
                StateMachine(parsed_json)
            else:
                connected = False
                connection.close()

        else:
            connected = False
    return


def StateMachine(parsed_json : dict) -> None:
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
    elif parsed_json["request"] == "GET_STATUS":
        GetStatus(parsed_json)
    return


def GetDiff(parsed_json : dict) -> None:
    return


def GetTeam(parsed_json : dict) -> None:
    _connection.sendall(
        json.dumps(
            {
                "send_timestamp": time.time(),
                "filename": parsed_json["data"]["teamnumber"] + ".team",
                "data": frcd.fileman.get_file(parsed_json["data"]["teamnumber"], FileTypes.Team)
            }
        ).encode("utf-8")
    )
    return


def GetMatch(parsed_json : dict) -> None:
    _connection.sendall(
        json.dumps(
            {
                "send_timestamp": time.time(),
                "filename": parsed_json["data"]["matchid"] + ".team",
                "data": frcd.fileman.get_file(parsed_json["data"]["matchid"], FileTypes.Match)
            }
        ).encode("utf-8")
    )
    return


def GetChunk(parsed_json : dict) -> None:
    _connection.sendall(
        json.dumps(
            {
                "send_timestamp": time.time(),
                "filename": parsed_json["data"]["chunkid"] + ".team",
                "data": frcd.fileman.get_file(parsed_json["data"]["chunkid"], FileTypes.Chunk)
            }
        ).encode("utf-8")
    )
    return


def PutTeam(parsed_json : dict) -> None:
    frcd.fileman.update_file(
        parsed_json["data"]["teamnumber"],
        FileTypes.Team,
        parsed_json["data"]
    )
    return


def PutMatch(parsed_json : dict) -> None:
    frcd.fileman.update_file(
        parsed_json["data"]["matchid"],
        FileTypes.Match,
        parsed_json["data"]
    )
    return


def PutChunk(parsed_json : dict) -> None:
    frcd.fileman.update_file(
        parsed_json["data"]["chunkid"],
        FileTypes.Chunk,
        parsed_json["data"]
    )
    return


def GetStatus(parsed_json : dict) -> None:
    return