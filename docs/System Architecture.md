---
title: System Architecture
nav_order: 1
parent: Docs
has_children: true
---

## System Architecture

#### Introduction
The FRC Detective system consists of two main components; the server, and the client.

The FRC Detective Server is written purely in Python 3 and distributed as a Docker Image File, with a separate install script, and should run on either Linux, Mac, or Windows without any issues. The server is designed so that it can be used without a GUI and in a headless state for use at competitions on small embedded systems, such as a battery-powered Raspberry Pi or similar systems. 

Unlike the server, the client application is written in C# and Xamarin, and can be compiled for both Android and iOS. It is designed specifically to be run without an internet connection 99% of the time it is open, until ready to sync with the server, to allow for match data to be collected while untethered.