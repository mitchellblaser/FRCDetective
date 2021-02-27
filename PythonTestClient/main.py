#########################################
# FRC Detective Project 2021            #
# Python Test Client                    #
# Mimics the sync process of a client,  #
#  but hosted locally on your computer. #
#########################################
import socket
import sys


sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
FakeRoundData = []


def ConvertIntToBytes(input):
    output = []
    for i in range(0, len(str(input))):
        output.append(int(str(input)[i]))
    print("ConvertIntToBytes(" + str(input) + "): " + str(output))
    return bytes(output)


def PadEpochTimeBytes(input):
    output = []
    for i in range(0, 8 - len(str(input))):
        output.append(0)
    for i in range(0, len(str(input))):
        output.append(int(str(input)[i]))
    print(str(bytes(output)))
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
    print("")


SetupSocket('localhost', 5584)
RoundList = ParseRoundList({'0-0-000-05584': 123456, '0-0-001-05584': 234567})
if SendRoundList(RoundList) == b'RECV_OK':
    print(GetDataToSend())
