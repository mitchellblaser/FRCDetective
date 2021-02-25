# FRC Detective
# Format.py
# Created 26-2-21

def PadNumber(_number, _length):
	return "0"*(_length-len(str(_number))) + str(_number)