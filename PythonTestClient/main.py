#########################################
# FRC Detective Project 2021            #
# Python Test Client                    #
# Mimics the sync process of a client,  #
#  but hosted locally on your computer. #
#########################################
import socket
import sys
import time
from pprint import pprint


sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


def GenerateTimestamp():
    #return PadEpochTimeBytes(int(time.time()))
    return int.to_bytes(int(time.time()), 8, "little")


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
    #print("".join("\\x%02x" % i for i in _data)) #display the hex
    
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
    #print(datalist)
    return datalist


def ConvertIntToBytes(input):
    output = []
    for i in range(0, len(str(input))):
        output.append(int(str(input)[i]))
    print("ConvertIntToBytes(" + str(input) + "): " + str(output))
    return bytes(output)


def ConvertIntToByte(input):
    output = []
    output.append(input)
    return bytes(output)


def PadEpochTimeBytes(input):
    output = []
    for i in range(0, 8 - len(str(input))):
        output.append(0)
    for i in range(0, len(str(input))):
        output.append(int(str(input)[i]))
    return bytes(output)


def SetupSocket(addr, port):
    global sock
    server_address = (str(addr), port)
    print("Connecting to %s:%s." % server_address)
    sock.connect(server_address)


def SendRoundList(data):
    global sock
    try:
        print("Sending round list with data: b'L' + " + str(data))
        sock.sendall(b'L')
        sock.sendall(data)
    finally:
        print("Finished Sending.")
    try:
        response = sock.recv(1024)
        print("Recieved Response: " + str(response))
    except:
        print("ERROR! Recieved no response from client.")
        response = b'NORESPONSE'
    return response


def ParseRoundList(dict):
    data = b''
    for i in range(0, len(dict)):
        key = list(dict.keys())[i]
        timestamp = dict[key]

        data = data + bytes(key, 'utf-8') + PadEpochTimeBytes(timestamp)
    return data


def GetDataToSend():
    try:
        response = sock.recv(1024)
        print("Recieved Data: " + str(response))
    except:
        print("ERROR! Recieved no data from client.")
        response = b'NODATA'
    return response


def SendRoundData(data):
    global sock
    try:
        print("Sending round data.")
        sock.sendall(data)
    finally:
        print("Finished Sending.")


def ParseServerRequirements(data):
    print("Parsing server requirements list")
    requirements = {'count': 0, 'rounds': []}
    KeyLength = 13
    i = 1
    while i < len(data):
        requirements['rounds'].append(bytes([data[i], data[i+1], data[i+2], data[i+3], data[i+4], data[i+5], data[i+6], data[i+7], data[i+8], data[i+9], data[i+10], data[i+11], data[i+12]]).decode('utf-8'))
        requirements['count'] = requirements['count'] + 1
        i = i + 13
    print("Server Wants: " + str(requirements))
    return requirements


SetupSocket('10.10.10.161', 5584)
RoundList = ParseRoundList({'0-0-001-05584': 123456, '0-0-003-05584': 234567})
if SendRoundList(RoundList) == b'RECV_OK':
    req = ParseServerRequirements(GetDataToSend())
    if req['count'] != 0:
        sock.sendall(b'R')
        response = sock.recv(1024)
        if response == b'RECV_OK':
            print("RECV_OK")
    for i in range(0, req['count']):
        print("Generating data for round " + req['rounds'][i] + "...")
        timestamp = GenerateTimestamp()
        print("    Timestamp (current):   " + str(int.from_bytes(timestamp, "little")))
        roundnumber = int.to_bytes(int(req['rounds'][i][4:7]), 1, "little")
        print("    Round Number:          " + str(int.from_bytes(roundnumber, "little")))
        if i == req['count']-1:
            endbyte = b'\x00' #change to x01 if sending more
        else:
            endbyte = b'\x01'
        print("    Data to send:          " + str(i+1) + " of " + str(req['count']) + " <End Byte=0x0" + str(int.from_bytes(endbyte, "little")) + ">")
        FakeRoundData = b'\x00\x11\x22\x33' + timestamp + b'\x00\x00' + roundnumber + int.to_bytes(5584, 4, "little") + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x00\x00\x00\x00\x00\x00\x00\x00' + endbyte
        SendRoundData(FakeRoundData)
        try:
            response = sock.recv(1024)
            if response == b'RECV_OK':
                print("Recieved Data: " + str(response))
        except:
            print("ERROR! Recieved no data from client.")
            response = b'NODATA'

    sock.sendall(b'S')
    try:
        response = sock.recv(1024)
        print("Recieved response from server: " + str(response))
    except:
        print("Error! No response from server.")
        response = b'NODATA'
    time.sleep(0.2)
    if response[0] == 68:
        print("Ready to receive data.")
        exit = False
        if response == b'':
            exit = True
        while exit == False:
            print("Run Loop")
            try:
                data = sock.recv(1024)
                #print(data)
                pprint(Parse(data))
                sock.sendall(b'RECV_OK')
                if data[40] == 0:
                    print("End Byte")
                    exit = True
            except:
                print("Error receiving data.")
                exit = True
        sock.close()
    else:
        sock.close()
            
