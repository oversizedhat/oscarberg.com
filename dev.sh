#!/bin/sh
export DEV_SERVER_PRIVATE_IP=http://localhost

# build drafts
if [ "$1" == "--with-drafts" ]
then
  export HUGO_FLAGS="-D"
fi

# start hugo dev server
exec docker-compose up