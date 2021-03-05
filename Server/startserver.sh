#!/bin/bash
docker run --rm --mount type=bind,source=/app/Storage.json,target=/app/Storage.json --mount type=bind,source=/app/app.db,target=/app/webgui/app.db --mount type=bind,source=/app/adminusers.txt,target=/app/webgui/adminusers.txt -e TZ=Australia/Melbourne -p 5584:5584 -p 8080:8080 --name detective-server detective-server
