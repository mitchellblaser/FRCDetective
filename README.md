# FRC Detective

**We are currently developing FRCD 2024!**
Keep yourself posted for updates soon.<br>
This version will be significantly closer to feature-complete than GameDay 2022 v1.0 Release. We will likely still not hit every feature on our wishlist, but we are planning to greatly improve our client-side application, and include a handful of new features. For more detail, check out the list below...

<img src="https://github.com/mitchellblaser/FRCDetective/blob/main/Readme/logo.png?raw=true" align=right width=225 />A scouting system for the First Robotics Competition which does not rely on an internet connection, or bluetooth/wifi mesh network.

Developed by [@mitchellblaser](https://github.com/mitchellblaser) and [@Dilka30003](https://github.com/Dilka30003).

View our progress and planned features for the future on GitHub Issues.

**What's working:**

- Server socket communications with FRCD2 JSON-Based Protocol
- Server Data Store/Reply for Matches, Teams, and Chunks.
- Multi-Platform Client Application targeting Android, iOS and Windows.
- Game Scouting Entry Page
- Team Leaderboard and Analysis

**Goals for 2024:**

- Pre-game match analysis and strategy breakdown.
- Individual User Logins, and logging per data entry.
- Synchronisation of match schedule from server to client.
- Blue Alliance match schedule and name import - offline file or online API.

**Future Goals:**

- Client TBA Schedule API Get
- Server Status Reporting over JSON Socket
- Client-side Schedule Adjustment (in case of variation from TBA)
- Match Prediction Algorithm

**Starting the server:**

Launch the `./detective.py` file inside the `server` folder with Python 3. Ensure your system has a local network connection, and the server will start running.

You will be prompted to complete a first-time setup, including creating an administrator login. Server data files will be initialised in `server/datastore/*`.

### Requirements (Server)

- Python 3
- pip install:
   flask
   flask-wtf
   waitress
   pathlib


