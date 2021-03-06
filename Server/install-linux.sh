#!/bin/bash

echo "FRC DETECTIVE - INSTALLER"
echo "========================="

echo " > Creating /etc/detective"
sudo mkdir /etc/detective
echo " > Copying Persistent files to directory."
sudo cp ./.installdata/* /etc/detective
echo " > Loading docker image from tar file."
sudo docker load -i ./detectiveserver-latest.tar
echo ""
echo " > Modifying start script with user variables..."
echo ""
echo ""
echo "Enter your timezone (eg. Australia/Melbourne)"
read USER_TIMEZONE
echo "Enter Web Management Interface Port (default 8080)"
read USER_WEBPORT
echo ""
echo "Thanks! Creating your script."

echo docker run --rm --mount type=bind,source=/etc/detective/Storage.json,target=/app/Storage.json --mount type=bind,source=/etc/detective/app.db,target=/app/webgui/app.db --mount type=bind,source=/etc/detective/adminusers.txt,target=/app/webgui/adminusers.txt -e TZ=$USER_TIMEZONE -p 5584:5584 -p $USER_WEBPORT:8080 --name detective-server detective-server > ./start-linux.sh
sudo chmod +x ./start-linux.sh