---
title: Development Environment and Build Instructions
nav_order: 2
parent: Docs
---

## Development Environment and Build Instructions

## Server

For users who do not want or need to modify the source code, we recommend using a Prebuilt Release from our <a href="/FRCDetective/download">Downloads Page</a>.

There are two release options - either a Docker image or raw Python 3 source files. 

#### Python Source Files

This is the simplest way to run the Server, especially for development, or if you are dedicating an entire machine to run the application exclusively.

It has a shorter setup time, and only depends on `python3` and `pip`.

Simply run `python3 ./detective.py`, and answer the questions when prompted for the initial setup. This will initialise server files in `server/datastore/*`.

#### Docker Image

Currently building a Docker image using our prebuilt script is outdated, and will need updating to regain this functionality.

A docker image is a little more complex to setup, although it has the advantage of being containerised, and highly stable.

---

> **For development systems running macOS or Linux, follow the instructions below. For Windows users, you will need to install the Windows Subsystem for Linux, and make sure you have python3, python3-pip, unzip and zip installed. If you are using WSL, don't install the Docker Engine through the package manager, but rather install the Windows version of Docker Desktop. It can be used through the command line the same way, and will produce less errors when you're trying to build.**

To build the source, you'll need to grab a few packages from python's `pip` package manager, and ensure you have either Docker Desktop or the Docker Engine installed.

You can install all of the required packages by running the command `python -m pip install -r ./server/requirements.txt`.
To install Docker, read the instructions on their website <a href="https://docs.docker.com/engine/install/">here</a>.

Once you've installed the dependencies, cd to `server` and run `./productionbuild.sh` (not as root, but as your normal user). If prompted, enter your password.

Once your build is complete, `cd ../../` (to the directory adjacent to your repository directory), and you'll see a new .zip file named `DetectiveServer-Release.zip`. To deploy this to another system, copy this file across now and follow the <a href="/docs/Installation Instructions">Installation Instructions</a> on our other page.

If you're wanting to test on your development system, but inside of the Docker Container, you can follow the same instructions, however you shouldn't need to install any additional dependencies - what you've installed for development should be more than enough.



## Client

To build the Client application for Windows computers and/or Android devices, you will require a Windows development environment. To compile for iOS or MacOS, you will require a Mac computer for a complilation machine, as we will need to use Xcode.

Firstly, install the following software...

```markdown
- Git for Windows
- Visual Studio 2022 Community
    - Desktop Development with C++ workload
- Android Studio 2022.3 or later
    - Android SDK Platform, API 33.0.0
    - Android SDK Command-line Tools
    - Android SDK Build-Tools
    - Android SDK Platform-Tools
    - Android Emulator
- Visual Studio Code
    - Flutter extension for VS Code
```

Now, open VS Code and when prompted, click *Download SDK* for flutter.

To be sure, run `flutter doctor`, and if all is well, you are able to press F5 to build.