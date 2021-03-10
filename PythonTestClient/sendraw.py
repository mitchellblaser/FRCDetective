import socket
import sys
import time

addr = sys.argv[1]
port = 5584

raw_data = sys.argv[2]
data = raw_data.split(",")

def send(data):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((addr, port))
    for i in range(0, len(data)):
        time.sleep(0.2)
        if is_raw(data[i]):
            print("Sending RAW:   " + str(data[i]))
            s.sendall(convert_raw(data[i]))
        else:
            print("Sending UTF-8: " + str(data[i]))
            s.sendall(bytes(data[i], "utf-8"))
    time.sleep(0.2)
    s.close()

def is_raw(data):
    if data[0] == 'x':
        return True
    else:
        return False

def convert_raw(data):
    output_bytes = []
    i = 0
    while i < len(data):
        numerical_string = str(data[i+1]) + str(data[i+2])
        numerical_out = int(numerical_string)
        output_bytes.append(numerical_out)
        i = i + 3
    return (bytes(output_bytes))

send(data)
