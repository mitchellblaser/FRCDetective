#!/bin/bash
rm ../../detectiveserver-latest.tar
docker build -t detective-server .
docker save --output ../../detectiveserver-latest.tar detective-server:latest
