import serial
import time

Image = [1,0,0,1,1,0,1,0,
         0,1,1,0,1,0,1,0,
         0,1,1,0,1,0,0,1,
         0,1,1,0,1,0,1,0,
         1,0,0,1,1,0,1,0,
         1,1,1,1,1,1,1,1,
         1,1,1,1,1,1,1,1,
         1,1,1,1,1,1,1,1,]

Imag2 = [1,1,1,1,1,1,1,1,
         1,1,1,1,1,1,1,1,
         1,1,1,1,1,1,1,1,
         1,1,1,1,1,1,1,1,
         1,1,1,1,1,1,1,1,
         1,1,1,1,1,1,1,1,
         1,1,1,1,1,1,1,1,
         1,1,1,1,1,1,1,1,]

_byte = b''
_data = []
_out = ""

s = serial.Serial('/dev/cu.usbmodem14201')
s.baudrate = 9600
s.timeout = 0.1
print(s.name)

time.sleep(3)

while True:

    s.write(bytes("9", 'utf-8'))
    for i in range(0,len(Image)):
        s.write(bytes(str(Image[i]), 'utf-8'))


    time.sleep(5)


    s.write(bytes("9", 'utf-8'))
    for i in range(0,len(Imag2)):
        s.write(bytes(str(Imag2[i]), 'utf-8'))

    time.sleep(5)
