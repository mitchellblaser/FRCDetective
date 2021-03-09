rm -rf migrations
rm app.db
rm adminusers.txt

export FLASK_APP="dev_webgui.py"
flask db init
flask db migrate
flask db upgrade

echo "" >> adminusers.txt
