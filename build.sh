#!/bin/bash

# Currently just hacked together for local use
# TODO setup properly in CI env (ssh keys, handle the different envs etc)
set -e

if [ $HUGO_DEPLOY_ENV = "production" ]
then
  HUGO_BASEURL="https://www.oscarberg.com"
elif [ $HUGO_DEPLOY_ENV = "stage" ]
then
  HUGO_BASEURL="https://oversizedhat.github.io/oscarberg.com-dev"
else
  HUGO_BASEURL="http://localhost:8080"
fi

echo "Building for $HUGO_DEPLOY_ENV"
echo "BaseURL: $HUGO_BASEURL"

# HUGO Build for correct site
docker run --rm \
  --volume $(pwd):/src \
  klakegg/hugo:ext-alpine \
  -b $HUGO_BASEURL \
  --minify