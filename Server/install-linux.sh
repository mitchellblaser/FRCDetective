#!/bin/bash

echo "FRC DETECTIVE - INSTALLER"
echo "========================="
echo "Note: use --persist next time to keep the data files"

PERSIST_DATA=false

for var in "@$"; do
    if [ $var = "--persist" ]; then
        PERSIST_DATA=true
    fi
done

echo " > Creating /etc/detective"
sudo mkdir /etc/detective
if [ $PERSIST_DATA = false ]; then
    echo " > Copying Persistent files to directory."
    sudo cp ./.installdata/* /etc/detective
fi
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

echo 'if [ $(id -u) -ne 0 ]' >> ./frcdetective
echo '    then echo "Please Run as Root."' >> ./frcdetective
echo '    exit' >> ./frcdetective
echo 'fi' >> ./frcdetective
echo docker run --rm --mount type=bind,source=/etc/detective/Storage.json,target=/app/Storage.json --mount type=bind,source=/etc/detective/app.db,target=/app/webgui/app.db --mount type=bind,source=/etc/detective/adminusers.txt,target=/app/webgui/adminusers.txt -e TZ=$USER_TIMEZONE -p 5584:5584 -p $USER_WEBPORT:8080 --name detective-server detective-server >> ./frcdetective
sudo chmod +x ./frcdetective
sudo cp ./frcdetective /usr/local/bin/frcdetective
sudo rm ./frcdetective

echo ""
echo "========================================"
echo "Run 'sudo frcdetective' to start server."
echo "========================================"