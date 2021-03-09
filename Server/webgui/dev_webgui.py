from app import app
from waitress import serve

app.run(host="0.0.0.0", port=8080)
#serve(app, host='0.0.0.0', port=8080)