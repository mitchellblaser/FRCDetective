from flask import render_template, flash, redirect, url_for, request, send_from_directory, send_file
from app import app, db
from app.forms import LoginForm, RegistrationForm
from app.models import User
from flask_login import current_user, login_user, logout_user, login_required
from werkzeug.urls import url_parse

import subprocess

@app.route("/")
@app.route("/index")
@login_required
def index():
    return render_template("index.html", title="Home")

@app.route("/login", methods=["GET", "POST"])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user is None or not user.check_password(form.password.data):
            flash("Invalid Username or Password.")
            return redirect(url_for("login"))
        login_user(user, remember=form.remember_me.data)
        next_page = request.args.get('next')
        if not next_page or url_parse(next_page).netloc != '':
            next_page = url_for("index")
        return redirect(next_page)
    return render_template("login.html", title="Sign In", form=form)

@app.route("/logout")
def logout():
    logout_user()
    return redirect(url_for("index"))

@app.route("/register", methods=["GET", "POST"])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    form = RegistrationForm()
    if form.validate_on_submit():
        user = User(username=form.username.data, email=form.email.data)
        user.set_password(form.password.data)
        db.session.add(user)
        db.session.commit()
        flash('Congratulations, you are now a registered user!')
        return redirect(url_for('login'))
    return render_template('register.html', title='Register', form=form)

@app.route("/log")
@login_required
def log():
    logfile = open("./webgui/logfile.txt", "r")
    return logfile.read()

@app.route("/command/<cmd>")
@login_required
def command(cmd):
    cmdfile = open("./webgui/cmdfile.txt", "w")
    cmdfile.write(str(cmd) + "\n" + current_user.username + "\n" + current_user.email)
    cmdfile.close()
    return ""

def ReadAdminFile():
    out = []
    adminfile = open("./webgui/adminusers.txt", "r")
    for line in adminfile:
        out.append(line.rstrip())
    return out

@app.route("/get/user/priv/<data>")
@login_required
def getuserpriv(data):
    if data in ReadAdminFile():
        return "admin"
    else:
        return "standard"

@app.route("/adminconsole")
@login_required
def adminconsole():
    if current_user.username in ReadAdminFile():
        users = User.query.all()
        userlist = ""
        usercount = 0
        for u in users:
            userlist = userlist + '<option value="' + u.username + '">' + u.username + "</option>"
            usercount = usercount + 1
        listhtml = '<select style="width: 200px" id="userlist" name="Users" size=' + str(5) + '>' + userlist + '</select>'
        adminlist = ""
        for data in ReadAdminFile():
            if adminlist == "":
                adminlist = data.rstrip()
            else:
                adminlist = adminlist + ", " + data.rstrip()
        return render_template('adminconsole.html', title='Admin Console', userlist=listhtml, adminlist=adminlist)
    else:
        return redirect(url_for("index"))

@app.route("/adminconsole/getuserdb")
@login_required
def getudb():
    if current_user.username in ReadAdminFile():
        return send_file('/app/webgui/app.db', as_attachment=True, cache_timeout=0)
    else:
        return "You do not have the permission for this."

@app.route("/adminconsole/elevateuser/<userid>")
@login_required
def elevateuser(userid):
    if current_user.username in ReadAdminFile():
        adminfile = open("./webgui/adminusers.txt", "a")
        adminfile.write("\n" + str(userid))
        adminfile.close()
        return str(userid)
    else:
        return "You do not have the permission for this."

@app.route("/adminconsole/deesculateuser/<userid>")
@login_required
def deesculateuser(userid):
    if current_user.username in ReadAdminFile():
        if len(ReadAdminFile()) > 1:
            out = []
            adminfile = open("./webgui/adminusers.txt", "r")
            for line in adminfile:
                if line.rstrip() != userid:
                    out.append(line.rstrip())
            adminfile.close()
            newadminfile = open("./webgui/adminusers.txt", "w")
            for line in out:
                newadminfile.write(line)
            newadminfile.close()
            return str(userid)
        else:
            return "Cannot remove user."
    else:
        return "You do not have the permission for this."