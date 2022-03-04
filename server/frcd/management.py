#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Import External Libs
import getpass
from pathlib import Path
from web_shell import app

# Import Internal Python Files
import frcd.motd

def init(is_server_first_run : bool) -> None:
    if is_server_first_run:
        print(frcd.motd.firstrun01)
        print(frcd.motd.firstrun02)
        username = input("USERNAME >>")
        password = getpass.getpass("PASSWORD >>")
        fullname = input("FULL NAME >>")
        print(frcd.motd.firstrun03)
        print(frcd.motd.firstrun04)
        Path(".frcdserver.conf").touch()
        Path("datastore").mkdir()
        Path("datastore/users").mkdir()
        Path("datastore/teams").mkdir()
        Path("datastore/matches").mkdir()
        Path("datastore/matchchunks").mkdir()
        userfile = open("datastore/users/" + username + ".cred", "w")
        userfile.write(username + "\n" + password + "\n" + "ADMIN" + "\n" + fullname)
        print(frcd.motd.firstrun05)
    return

def serve(management_port : int) -> None:
    """Set up and serve web management interface.
    Must be run in it's own thread as it is a
    blocking function.

    Args:
        management_port (int): [Port for server]
    """
    app.serve_app(management_port)
    return

# Ensure our package is able to run standalone for testing.
if __name__ == "__main__":
    serve()