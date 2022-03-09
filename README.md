# FRC Detective

**The 2022 Update is out!**
(a.k.a. the "We're going to comp tomorrow edition")<br>
This version doesn't have *every* feature we'd like to have implemented yet, but it's built on our new stack, and has been rewritten from the ground up to be more efficient and readable. View what is currently working or not working below...

<img src="https://github.com/mitchellblaser/FRCDetective/blob/main/Readme/logo.png?raw=true" align=right width=225 />A scouting system for the First Robotics Competition which does not rely on an internet connection, or bluetooth/wifi mesh network.

Developed by [@mitchellblaser](https://github.com/mitchellblaser) and [@Dilka30003](https://github.com/Dilka30003).

View our progress and planned features for the future on GitHub Issues.

**What's working:**

- Server Data Read/Write
- Server Socket Communications with Detective 2.0 JSON-Based Protocol
- Client Server Socket Connection
- Client Multi-Platform Targeting thanks to the Flutter Framework
- Client Round Entry Page

**What's not working:**

- Server/Client Login Handshakes
- Client Team Analysis - **This will be working before the competition - coming soon!**
- Client TBA Schedule API Get
- Server Schedule Sync to/from Clients to reduce reliance on network connection
- Automatic Round Selection based on Schedule (if applicable)
- Server Status Reporting over JSON Socket
- Client Schedule Reporting
- Match Prediction Algorithm



**Starting the server:**

Launch the `./detective.py` file inside the `server` folder with Python 3. Ensure your system has a network connection, and the server will start running.

### Requirements (Server)

- Python 3
- pip install:
   flask
   flask-wtf
   waitress

