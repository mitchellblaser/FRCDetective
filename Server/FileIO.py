# FRC Detective
# FileIO.py
# Created 5-2-21

import json

def SaveData(_filepath, _data):
	with open(_filepath, "w") as write_file:
		json.dump(_data, write_file)
		write_file.close()

def ReadData(_filepath):
	with open(_filepath, "r") as read_file:
		data = json.load(read_file)

def AppendData(_filepath, _key, _data):
	print(_filepath)
	print(_key)
	print(_data)
	with open(_filepath, "r") as read_file:
		data = json.load(read_file)
	data[_key] = _data
	with open(_filepath, "w") as write_file:
		json.dump(data, write_file)
		write_file.close()