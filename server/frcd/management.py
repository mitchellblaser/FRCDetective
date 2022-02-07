#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Import External Libs
import os
from http.server import HTTPServer, CGIHTTPRequestHandler

def serve(is_server_first_run, management_port):
    """Set up and serve web management interface.
    Must be run in it's own thread as it is a
    blocking function.

    Args:
        is_server_first_run (bool): [Decides to show setup page]
        management_port (int): [Port for server]
    """
    os.chdir("./web_shell")
    server = HTTPServer(server_address=("", management_port),
    RequestHandlerClass=CGIHTTPRequestHandler)
    server.serve_forever()

# Ensure our package is able to run standalone for testing.
if __name__ == "__main__":
    serve()