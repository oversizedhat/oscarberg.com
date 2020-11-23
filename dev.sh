#!/bin/sh
export DEV_SERVER_PRIVATE_IP=$(hostname -I | awk '{print $1}')

# launch browser
sensible-browser $DEV_SERVER_PRIVATE_IP:8080

# start hugo dev server
exec docker-compose up