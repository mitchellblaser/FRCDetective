# FRC Detective



<img src="https://github.com/mitchellblaser/FRCDetective/blob/main/Readme/logo.png?raw=true" align=right width=225 />A scouting system for the First Robotics Competition which does not rely on an internet connection, or bluetooth/wifi mesh network.

Developed by [@mitchellblaser](https://github.com/mitchellblaser) and [@Dilka30003](https://github.com/Dilka30003).

View our progress and planned features for the future [at this link.](https://app.gitkraken.com/glo/board/YBvMzRdxdwARfCdr)



**Starting the server:**

The server requries Python 3 (and some additional libraries - mentioned below) to be installed. Once you've got it, you can just run:<img src="https://github.com/mitchellblaser/FRCDetective/blob/main/Readme/Server%20Window.png?raw=true" align=right width=350>

If you're on a UNIX system, you can run the following command:

```bash
./detective -p [port]
```

For windows, you may need to run python3 ./detective, and then your options.

The full list of possible command line arguments are:

```bash
--address (-a) [IP ADDRESS]
  Set the address for the server
  (usually just use localhost)

--port (-p) [PORT] (Required)
  Set the port to connect to

--debug (-d) [True/False]
  Show debug messages

--graphics (-g) [windowed/lowlevel]
  Set the graphics mode
  (lowlevel for led output on raspberry pi)
```



### Requirements (Server)

***The server application is not complete as of yet.***

- Python 3
- socket, tkinter, os, datetime (should all come with py3 install)
- pillow (pip3 install pillow)

