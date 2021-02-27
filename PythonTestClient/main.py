#########################################
# FRC Detective Project 2021            #
# Python Test Client                    #
# Mimics the sync process of a client,  #
#  but hosted locally on your computer. #
#########################################
import socket
import sys
import time


sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


def GenerateTimestamp():
    #return PadEpochTimeBytes(int(time.time()))
    return int.to_bytes(int(time.time()), 8, "little")


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
        sock.sendall(b'R')
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


SetupSocket('localhost', 5584)
RoundList = ParseRoundList({'0-0-001-05584': 123456, '0-0-003-05584': 234567})
if SendRoundList(RoundList) == b'RECV_OK':
    req = ParseServerRequirements(GetDataToSend())

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
        print("Recieved response from server.")
    except:
        print("Error! No response from server.")
        response = b'NODATA'

    time.sleep(0.2)
    if response[0] == 68:
        print("Ready to receive data.")
        exit = False
        while exit == False:
            print("Run Loop")
            try:
                data = sock.recv(1024)
                print(data)
                if data[33] == 0:
                    print("End Byte")
                    exit = True
            except:
                print("Error receiving data.")
            sock.sendall(b'RECV_OK')
