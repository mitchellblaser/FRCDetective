#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Import External Libs
import os
import enum
import json

class FileTypes(enum.Enum):
    Team = 1
    Match = 2
    Chunk = 3

def update_file(filename, type, contents):
    if type == FileTypes.Team:
        f = open("./datastore/teams/" + filename + ".team", "a")
        f.write(json.dumps(contents) + "\n")
        f.close()
    return