---
title: Installation Instructions
nav_order: 3
parent: Docs
---

## Installation Instructions

#### Server
To install a prebuilt release of the FRC Detective Server application, which has been tested and verified to work, download it from our website, and upload it to your server/computer.

For the Server to work, you'll need to have the Docker engine installed on your system. If you don't already have it, read the instructions <a href="https://docs.docker.com/engine/install/">here.</a> For Linux systems, you'll want the Docker Engine, and Windows/Mac users will need to get the entire Docker Desktop application.

Once Docker's installed, grab a copy of the latest Server Release from our <a href="/download">Download Page</a>.

<br>
##### Linux Instructions:
Move to your Downloads directory and run `unzip ./DetectiveServer-Release.zip && cd DetectiveServer-Release`. If you don't have the unzip binary installed, use your package manager to  get it. Now that you're in the directory, run `./install-linux.sh` (**not** as root, but as your default user.) If prompted, enter your user password for the sudo command.

Inside the Installation Script, we'll load the docker image in, copy the required files to /etc/detective on your disk, and install a `frcdetective` binary that you can launch from the command line once finished.

When prompted, enter the timezone you use from the TZ Database (<a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">see here if unsure</a>), and the port you would like to access the Web UI from. By default we recommend using Port 8080, but if your system is used exclusively for the FRC Detective, Port 80 might be easier, as you can access the UI directly, without using `http://address:port/`.

After the installation is complete, you can start the server by running `sudo frcdetective`, and log onto the web server by going to `localhost`, or your system's external IP. The first user to login to the Web Interface will automatically be given Administrator Permissions, and afterwards more users can be added to the Admin Console by the initial user, after they register.