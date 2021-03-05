#!/bin/bash

rm ./Storage.json
echo "{}" >> ./Storage.json

cd webgui
./generatedatabase.sh

cd ..
sudo ./dockerbuild.sh