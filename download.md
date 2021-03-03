---
title: Download
nav_order: 2
---

## Download

#### Client

The FRC Detective Client is written in C# and Xamarin, and currently needs to be built from the source for both iOS and Android. When we have a working and tested build for the app for the 2021 Season, we will publish Android APK builds here, although as we don't have an Apple Developer Account, iOS builds will still need to be done manually from the source.

<a class="btn"><i class="fa fa-download"></i> Download Client (Android)</a>          <a class="btn"><i class="fa fa-download"></i> Download Source (Required for iOS)</a>

<br>

#### Server

The Server is written in Python 3, and has been tested in versions 3.8+. It supports any Linux, Windows and MacOS system with the tkinter and pillow libraries.

On Unix systems, you can start the detective with `./detective -p [port]`. On systems where that doesn't work (Windows, etc..), you can start it with `python3 ./main.py -p [port]`.

<a class="btn" href="/download/DetectiveServer-DevRel001.zip"><i class="fa fa-download"></i> Download Server</a>         

