#!/bin/bash

flask db init
export FLASK_APP="webgui.py"
flask db migrate
flask db upgrade
