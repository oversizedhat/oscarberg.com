#!/bin/sh
export DEV_SERVER_PRIVATE_IP=$(hostname -I | awk '{print $1}')

# build drafts
if [ "$1" == "--with-drafts" ]
then
  export HUGO_FLAGS="-D"
fi

# launch browser
sensible-browser $DEV_SERVER_PRIVATE_IP:8080

# start hugo dev server
exec docker-compose up