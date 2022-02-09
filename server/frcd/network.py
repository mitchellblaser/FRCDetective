#!/usr/bin/python3
############################################
#                                          #
#  THE FRC DETECTIVE PROJECT               #
#  GITHUB.COM/MITCHELLBLASER/FRCDETECTIVE  #
#                                          #
############################################

# Get Configuration Options
from configuration import FRCD_SERVER_SOCKET_PORT

# Import External Libs
import socket

# Sets up Main Socket for Handling Client Requests.
# Returns type socket.socket
def ConfigureMainSocket() -> socket.socket:
    """Sets up a socket with pre-configured options.
    To be saved to a variable locally for use later.

    Returns:
        socket.socket: Socket, pre-configured.
    """
    main_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    main_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    socket_address = ("", FRCD_SERVER_SOCKET_PORT)
    main_sock.bind(socket_address)
    main_sock.listen(1)
    return main_sock