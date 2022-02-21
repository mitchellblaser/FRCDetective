from flask import Flask
from flask import render_template
from waitress import serve as wserve

app = Flask(__name__)

def serve_app(management_port: int):
    wserve(app, host="0.0.0.0", port=management_port)

@app.route('/')
@app.route('/index')
def index():
    return render_template("index.html")