---
title: System Architecture
nav_order: 1
parent: Docs
has_children: true
---

## System Architecture

#### Introduction
The Detective consists of two main components; the server, and the client.

The FRC Detective Server is written purely in Python 3, and can run on either Linux, Mac, or Windows without any issues. The server is designed so that it can be used without a GUI and in a headless state for use at competitions on small embedded systems, such as a battery-powered Raspberry Pi or similar.

Unlike the server, the client application is written in C# and Xamarin, and can be compiled for both Android and iOS. It is designed specifically to be run without an internet connection 99% of the time it is open, until ready to sync with the server, to allow for match data to be collected while untethered.

Currently, the Server Application only supports one connected client at a time, due to limitations of TCP/IP, however in the future we are looking to support either multiple clients connected at the same time, or a waitlist type system, for situations where the server is hosted remotely, and connected to over the internet.

![](/assets/NetworkArchitecture01.png)