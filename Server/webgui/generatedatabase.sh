rm -rf migrations
rm app.db
rm adminusers.txt

export FLASK_APP="dev_webgui.py"
python3 -m flask db init
python3 -m flask db migrate
python3 -m flask db upgrade

echo "" >> adminusers.txt
