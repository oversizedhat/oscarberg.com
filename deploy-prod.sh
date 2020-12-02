#!/bin/bash

set -e

# Currently just hacked together for local use
# TODO setup properly in CI env (ssh keys, handle the different envs etc)
bash build.sh

# SFTP deploy
sftp oscarberg.com@ssh.oscarberg.com <<< $'put -r docs/*'