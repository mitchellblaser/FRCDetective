#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Import External Libs
from functools import partial
import os
from http.server import HTTPServer, SimpleHTTPRequestHandler
import getpass
from pathlib import Path

# Import Internal Python Files
import frcd.motd

def init(is_server_first_run):
    if is_server_first_run:
        print(frcd.motd.firstrun01)
        print(frcd.motd.firstrun02)
        username = input("USERNAME >>")
        password = getpass.getpass("PASSWORD >>")
        print(frcd.motd.firstrun03)
        print(frcd.motd.firstrun04)
        Path(".frcdserver.conf").touch()
        Path("datastore").mkdir()
        Path("datastore/users").mkdir()
        Path("datastore/teams").mkdir()
        Path("datastore/matches").mkdir()
        Path("datastore/matchchunks").mkdir()
        userfile = open("datastore/users/" + username + ".cred", "w")
        userfile.write(username + "\n" + password + "\n" + "ADMIN")
        print(frcd.motd.firstrun05)
    return

def serve(management_port):
    """Set up and serve web management interface.
    Must be run in it's own thread as it is a
    blocking function.

    Args:
        management_port (int): [Port for server]
    """
    Handler = partial(SimpleHTTPRequestHandler, directory="./web_shell")

    server = HTTPServer(server_address=("", management_port),
    RequestHandlerClass=Handler)
    server.serve_forever()

# Ensure our package is able to run standalone for testing.
if __name__ == "__main__":
    serve()