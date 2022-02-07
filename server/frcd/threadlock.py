#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Import External Libs
import threading

# Import Internal Python Files
from frcd.filetypes import FileTypes

class Locker:
    _instance = None
    _lock = threading.Lock()
    _lockdict = {}

    for i in range(1, len(FileTypes)+1):
        _lockdict[i] = False

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            with cls._lock:
                if not cls._instance:
                    cls._instance = super(Locker, cls).__new__(cls)
        return cls._instance

    def GetLock(self, id : FileTypes) -> None:
        while True:
            if self._lockdict[id] == False:
                self._lockdict[id] = True
                return

    def Release(self, id : FileTypes) -> None:
        self._lockdict[id] = False