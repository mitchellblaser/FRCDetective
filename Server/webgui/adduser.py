# Standalone script to create user in the WebApp Database.

from app import db
from app.models import User

_type = input("Type (admin/standard): ")

if _type == "admin" or _type == "standard":
    print("Selected Type " + str(_type) + ".")
else:
    print("Invalid Account Type.")
    exit()

_username = input("Username: ")
_email = input("Email: ")
_password = input("Password: ")
_password2 = input("Confirm Password: ")

if (_password == _password2):
    u = User(username=_username, email=_email)
    u.set_password(_password)
    db.session.add(u)
    db.session.commit()
    if _type == "admin":
        of = open("adminusers.txt", "r")
        filelines = []
        for line in of:
            filelines.append(line.rstrip())
        print(filelines)
        
        if len(filelines) <= 1 and filelines[0] == "":
            nf = open("adminusers.txt", "w")
            nf.write(str(_username))
        else:
            nf = open("adminusers.txt", "a")
            nf.write("\n" + str(_username))
        nf.close()
else:
    print("Passwords do not match. No changes made.")
