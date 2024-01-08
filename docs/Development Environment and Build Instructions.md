---
title: Development Environment and Build Instructions
nav_order: 2
parent: Docs
---

## Development Environment and Build Instructions

#### Server
For users who do not want or need to modify the source code, we recommend using a Prebuilt Release from our <a href="/download">Downloads Page</a>.

Building the Server from Source is relatively easy, as we've made a script that does it all for you. If you're using Linux, macOS or the Windows Subsystem for Linux, the build script should just work.

---
>**For development systems running macOS or Linux, follow the instructions below. For Windows users, you will need to install the Windows Subsystem for Linux, and make sure you have python3, python3-pip, unzip and zip installed. If you are using WSL, don't install the Docker Engine through the package manager, but rather install the Windows version of Docker Desktop. It can be used through the command line the same way, and will produce less errors when you're trying to build.**

To build the source, you'll need to grab a few packages from python's `pip` package manager, and ensure you have either Docker Desktop (for macOS) or the Docker Engine (for Linux) installed.

You can install all of the required packages by running the command `pip3 install flask flask-wtf flask-login flask-sqlalchemy flask-migrate flask-bootstrap email-validator waitress`.
To install Docker, read the instructions on their website <a href="https://docs.docker.com/engine/install/">here</a>.

Once you've installed the dependencies, cd to `FRCDetective/Server` (ensure you are in the server folder) and run `./productionbuild.sh` (not as root, but as your normal user). If prompted, enter your password.

*If you are still testing your code changes, you can run `python3 main.py -a 127.0.0.1` from the Server directory and test your code changes live on your system, outside of the container. Currently, upload and download of server files does not work outside of the Docker container, and we don't officially support this method of running the server application.*

Once your build is complete, `cd ../../` (to the directory adjacent to your repository directory), and you'll see a new .zip file named `DetectiveServer-Release.zip`. To deploy this to another system, copy this file across now and follow the <a href="/docs/Installation Instructions">Installation Instructions</a> on our other page.

If you're wanting to test on your development system, but inside of the Docker Container, you can follow the same instructions, however you shouldn't need to install any additional dependencies - what you've installed for development should be more than enough.