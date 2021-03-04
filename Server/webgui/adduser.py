# Standalone script to create user in the WebApp Database.

from app import db
from app.models import User

#_type =      input("Type (admin/standard): ")
_username =  input("Username: ")
_email =     input("Email: ")
_password =  input("Password: ")
_password2 = input("Confirm Password: ")

u = User(username=_username, email=_email)
u.set_password(_password)
db.session.add(u)
db.session.commit()