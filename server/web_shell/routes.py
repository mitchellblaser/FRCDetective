import sys
sys.path.append("..")
from frcd.management import app

@app.route('/')
@app.route('/index')
def index():
    return "Hello, World!"