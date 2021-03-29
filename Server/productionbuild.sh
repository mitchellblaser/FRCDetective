#!/bin/bash

echo "FRC DETECTIVE PRODUCTION-READY BUILD SCRIPT"
echo "==========================================="

echo "Removing Round Data"
sudo rm ./Storage.json
sudo rm ./Picklist.json
echo "Creating Blank Round Data"
echo "{}" >> ./Storage.json
echo "{}" >> ./Picklist.json
echo "Moving to ./webgui"
cd webgui
echo "Generating Database File"
sudo rm -rf migrations
./generatedatabase.sh
echo "Moving to .."
cd ..
echo "Attempting to remove existing directory"
sudo rm -rf ../../DetectiveServer-Release
sudo rm -rf ../../DetectiveServer-Release.zip
echo "Making Directory ../../DetectiveServer-Release"
mkdir ../../DetectiveServer-Release
echo "Building Docker Image"
sudo docker build -t detective-server .
echo "Saving Docker Image to Release Folder"
sudo docker save --output ../../DetectiveServer-Release/detectiveserver-latest.tar detective-server:latest
echo "Making Directory ../../DetectiveServer-Release/.installdata"
mkdir ../../DetectiveServer-Release/.installdata
echo "Copying Empty Data Files."
cp ./Storage.json ../../DetectiveServer-Release/.installdata/Storage.json
cp ./Picklist.json ../../DetectiveServer-Release/.installdata/Picklist.json
cp ./webgui/adminusers.txt ../../DetectiveServer-Release/.installdata/adminusers.txt
cp ./webgui/app.db ../../DetectiveServer-Release/.installdata/app.db

echo "Copying Install Script to ../../DetectiveServer-Release"
cp ./install-linux.sh ../../DetectiveServer-Release/install-linux.sh
echo "Packaging script into ../../DetectiveServer.zip"
sudo chmod 666 ../../DetectiveServer-Release/detectiveserver-latest.tar
cd ../../
zip -r DetectiveServer-Release.zip DetectiveServer-Release
sudo rm -rf ./DetectiveServer-Release
echo ""
echo " >>>> DONE! <<<<"
