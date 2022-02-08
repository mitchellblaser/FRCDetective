#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Import External Libs
import time
import json

# Import Internal Python Files
import frcd.threadlock
from frcd.filetypes import FileTypes

lock = frcd.threadlock.Locker()

def update_file(filename : str, type : FileTypes, contents : dict) -> None:
    #TODO: This function needs to be smarter so that it can attempt
    #      to merge multiple versions of the same file together
    #      e.g. one device makes a change, syncs it, another device
    #      makes a separate change, but does not have the last update
    #      yet. In the event we have two conflicting data points inside
    #      of the same file that isn't the same modification from two
    #      different clients, we'll prioritise the newer of the two.
    lock.GetLock(type)
    if type == FileTypes.Team:
        f = open("./datastore/teams/" + filename + ".team", "a")
    elif type == FileTypes.Match:
        f = open("./datastore/matches/" + filename + ".match", "a")
    elif type == FileTypes.Chunk:
        f = open("./datastore/matchchunks/" + filename + ".chunk", "a")
    f.write(json.dumps(contents) + "\n")
    f.close()
    lock.Release(type)
    return

def get_file(filename: str, type : FileTypes) -> str:
    lock.GetLock(type)
    if type == FileTypes.Team:
        f = open("./datastore/teams/" + filename + ".team", "r")
    elif type == FileTypes.Match:
        f = open("./datastore/matches/" + filename + ".match", "r")
    elif type == FileTypes.Chunk:
        f = open("./datastore/matchchunks/" + filename + ".chunk", "r")
    contents = f.read()
    f.close()
    lock.Release(type)
    return contents