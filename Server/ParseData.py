# FRC Detective
# ParseData.py
# Created 7-2-21

def Parse(_data):
	datalist = {
		"UID" : 0,
		"Timestamp" : 0,
		"Division" : 0,
		"RoundType" : 0,
		"RoundNumber" : 0,
		"TeamNumber" : 0,
		"Alliance" : 0,
		"Auto-InitiationLine" :0,
		"Auto-TopBalls" : 0,
		"Auto-BottomBalls" : 0,
		"Teleop-TopBalls" : 0,
		"Teleop-BottomBalls" : 0,
		"Teleop-ColorWheelRotation" : 0,
		"Teleop-ColorWheelPosition" : 0,
		"Teleop-Climb" : 0,
		"Teleop-Switch" : 0,
		"Fouls" : 0,
		"TechFouls" : 0,
		"StartHash" : 0,
		"Hash" : 0,
		"End" : 0
	}
	print("".join("\\x%02x" % i for i in _data)) #display the hex
	
	datalist["UID"] = int.from_bytes([_data[0], _data[1], _data[2], _data[3]], "little")
	datalist["Timestamp"] = int.from_bytes([_data[4], _data[5], _data[6], _data[7], _data[8], _data[9], _data[10], _data[11]], "little")
	datalist["Division"] = int.from_bytes([_data[12]], "little")
	datalist["RoundType"] = int.from_bytes([_data[13]], "little")
	datalist["RoundNumber"] = int.from_bytes([_data[14]], "little")
	datalist["TeamNumber"] = int.from_bytes([_data[15], _data[16], _data[17], _data[18]], "little")
	datalist["Alliance"] = int.from_bytes([_data[19]], "little")
	datalist["Auto-InitiationLine"] = bool.from_bytes([_data[20]], "little")
	datalist["Auto-TopBalls"] = int.from_bytes([_data[21]], "little")
	datalist["Auto-BottomBalls"] = int.from_bytes([_data[22]], "little")
	datalist["Teleop-TopBalls"] = int.from_bytes([_data[23]], "little")
	datalist["Teleop-BottomBalls"] = int.from_bytes([_data[24]], "little")
	datalist["Teleop-ColorWheelRotation"] = bool.from_bytes([_data[25]], "little")
	datalist["Teleop-ColorWheelPosition"] = bool.from_bytes([_data[26]], "little")
	datalist["Teleop-Climb"] = int.from_bytes([_data[27]], "little")
	datalist["Teleop-Switch"] = bool.from_bytes([_data[28]], "little")
	datalist["Fouls"] = int.from_bytes([_data[29]], "little")
	datalist["TechFouls"] = int.from_bytes([_data[30]], "little")
	datalist["StartHash"] = _data[31]
	datalist["Hash"] = int.from_bytes([_data[32], _data[33], _data[34], _data[35], _data[36], _data[37], _data[38], _data[39]], "little")
	datalist["End"] = int.from_bytes([_data[40]], "little")

	return datalist


def ParseRoundList(_data):
	datalist = {}
	print("".join("\\x%02x" % i for i in _data)) #display the hex
	print("LENGTH:      " + str(len(_data)) + "b")

	#Length of data (in bytes)
	MatchLength = 13
	TimestampLength = 8

	i = 1 ## ignore byte zero - it's b'L' to designate list mode
	while i < len(_data):
		key = bytes([ _data[i], _data[i+1], _data[i+2], _data[i+3], _data[i+4], _data[i+5], _data[i+6], _data[i+7], _data[i+8], _data[i+9], _data[i+10], _data[i+11], _data[i+12] ]).decode("utf-8")
		timestamp = int.from_bytes([_data[i+13], _data[i+14], _data[i+15], _data[i+16], _data[i+17], _data[i+18], _data[i+19], _data[i+20]], "little")
		print(str(key) + ": " + str(timestamp))
		datalist[str(key)] = int(timestamp)
		i = i + MatchLength + TimestampLength

	print(datalist)
	return datalist


def NeedsToClientBytes(_data):
	output = b'N'
	for i in range(0, len(_data['ServerNeeds'])):
		print(_data['ServerNeeds'][i])
		output = output + bytes(_data['ServerNeeds'][i], 'utf-8')
	return output


