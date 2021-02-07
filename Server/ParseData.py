# FRC Detective
# ParseData.py
# Created 7-2-21

def Parse(_data):
	##Currently, we just print the data.
	print("".join("\\x%02x" % i for i in _data)) 

	