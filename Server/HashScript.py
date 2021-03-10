# FRC Detective
# HashScript.py
# Created 4-2-21

import ParseData

def ProcessRound(data):
	_Hash = 0
	for i in range(0, len(data)-3): #ignore start/hash/end values
		_Hash = _Hash + data[ParseData.DATALIST[i]]
	return _Hash