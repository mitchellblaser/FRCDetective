#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Import External Libs
import json
import os

# Import Internal Python Files
import frcd.threadlock
from frcd.filetypes import FileTypes

lock = frcd.threadlock.Locker()

def __return_file_object__(filename : str, type : FileTypes, operation : str) -> open:
    #README: Before calling this function you should obtain a thread lock.
    if type == FileTypes.Team:
        f = open("./datastore/teams/" + filename + ".team", operation)
    elif type == FileTypes.Match:
        f = open("./datastore/matches/" + filename + ".match", operation)
    elif type == FileTypes.Chunk:
        f = open("./datastore/matchchunks/" + filename + ".chunk", operation)
    return f

def update_file(filename : str, type : FileTypes, contents : dict) -> None:
    lock.GetLock(type)
    f = __return_file_object__(filename, type, "a")
    f.write(json.dumps(contents) + "\n")
    f.close()
    lock.Release(type)
    return

def get_file(filename: str, type : FileTypes) -> str:
    lock.GetLock(type)
    f = __return_file_object__(filename, type, "r")
    contents = f.read()
    f.close()
    lock.Release(type)
    return contents

def get_version_list(filename : str, type : FileTypes) -> list:
    #README: EACH ENTRY MUST HAVE A "epoch_since_modify" AND A "user" KEY VALUE PAIR.
    lock.GetLock(type)
    f = __return_file_object__(filename, type, "r")
    contents = f.readlines()
    f.close()
    lock.Release(type)

    versions = []
    for line in contents:
        _line = line.rstrip()
        _json = json.loads(_line)
        versions.append(_json["user"] + str(_json["epoch_since_modify"]))
    return versions


def get_file_list() -> dict:
    # -> dict:
    # {
    #   "teams": {
    #     "5584.team": ["username_0000.000000", "username_00012133.12127899"],
    #     "1234.team": ["username_0000.000000", "username_00012133.12127899"],
    #   }
    # }

    teams = os.listdir("./datastore/teams")
    _teams = {}
    for team in teams:
        if team[-5:] == ".team":
            _teams[team[:-5]] = get_version_list(team[:-5], FileTypes.Team)

    matches = os.listdir("./datastore/matches")
    _matches = {}
    for match in matches:
        if match[-6:] == ".match":
            _matches[match[:-6]] = get_version_list(match[:-6], FileTypes.Match)

    chunks = os.listdir("./datastore/matchchunks")
    _chunks = {}
    for chunk in chunks:
        if chunk[-6:] == ".chunk":
            _chunks[chunk[:-6]] = get_version_list(chunk[:-6], FileTypes.Chunk)

    return {
        "teams": _teams,
        "matches": _matches,
        "chunks": _chunks
    }


#TODO: Implement user get function - needs more info eg email?

#TODO: Implement schedule stuff