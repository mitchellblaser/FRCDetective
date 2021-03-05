#!/bin/bash
rm ../../detectiveserver-latest.tar
sudo docker build -t detective-server .
sudo docker save --output ../../detectiveserver-latest.tar detective-server:latest
