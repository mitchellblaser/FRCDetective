import os
from flask import Flask, redirect, url_for, render_template
from waitress import serve as wserve
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired

app = Flask(__name__)
app.config['SECRET_KEY'] = "1234"

def serve_app(management_port: int):
    wserve(app, host="0.0.0.0", port=management_port)

@app.route('/')
@app.route('/index')
def index():
    uc = len(os.listdir("datastore/users"))
    mc = len(os.listdir("datastore/matches"))
    cc = len(os.listdir("datastore/matchchunks"))
    tc = len(os.listdir("datastore/teams"))
    
    return render_template("index.html", usercount=uc, matchcount=mc, chunkcount=cc, teamcount=tc)

class LoginForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    password = PasswordField("Password", validators=[DataRequired()])
    submit = SubmitField("Sign In")

@app.route("/login", methods=["GET", "POST"])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        return redirect("/index")
    return render_template("login.html", form=form)