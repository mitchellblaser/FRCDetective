#!/bin/bash

rm -rf migrations
rm app.db
rm adminusers.txt

flask db init
export FLASK_APP="webgui.py"
flask db migrate
flask db upgrade

echo "" >> adminusers.txt