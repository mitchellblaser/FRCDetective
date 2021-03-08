# FRC Detective
# Database.py
# Created 25-2-21

import FileIO

def GetKeyList():
	data = FileIO.ReadData("Storage.json")
	key_list = list(data.keys())
	return key_list


def Difference(ServerDataList, ClientDataList):
	ServerNeeds = []
	ClientNeeds = []

	##Check if the client has something the server does not
	for keys in ClientDataList:
		if keys in ServerDataList:
			##Check if date is newer client-side: recieve if it is.
			if CheckClientModifiedDate(ClientDataList, keys) > CheckServerModifiedDate(keys):
				#print("DB -> Client Key " + keys + " has a newer version.")
				ServerNeeds.append(keys)
		else:
			#print("DB -> Client Key " + keys + " does not exist on server.")
			ServerNeeds.append(keys)

	##Check if the server has something the client does not
	for keys in ServerDataList:
		if keys in ClientDataList:
			##Check if date is newer server-side: send if it is.
			if CheckServerModifiedDate(keys) > CheckClientModifiedDate(ClientDataList, keys):
				#print("DB -> Server Key " + keys + " has a newer version.")
				ClientNeeds.append(keys)
		else:
			#print("DB -> Server Key " + keys + " does not exist on client.")
			ClientNeeds.append(keys)

	return {"ServerNeeds": ServerNeeds, "ClientNeeds": ClientNeeds}


def CheckServerModifiedDate(_key):
	return int(FileIO.ReadData("Storage.json")[_key]["Timestamp"])


def CheckClientModifiedDate(_data, _key):
	return _data[_key]