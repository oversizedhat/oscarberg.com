#!/bin/bash

# Currently just hacked together for local use
# TODO setup properly in CI env (ssh keys, handle the different envs etc)

set -e

# HUGO Build for correct site
docker run --rm -it \
  --volume $(pwd):/src \
  klakegg/hugo:0.78.0-alpine \
  -b https://www.oscarberg.com \
  --minify

# SFTP deploy
sftp oscarberg.com@ssh.oscarberg.com:oscarbergcom <<< $'put -r docs/*'