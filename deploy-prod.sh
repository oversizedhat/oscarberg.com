#!/bin/bash
set -e

if [ "$1" != "-y" ]
then
  echo "Run with -y as argument to indicate you know what you are doing..."
  exit 1
fi

if [ $HUGO_DEPLOY_ENV != "production" ]
then
  echo "HUGO_DEPLOY_ENV must be set to production"
  exit 1
fi

# SFTP deploy (Currently not possible from Travis)
sftp oscarberg.com@ssh.oscarberg.com <<< $'put -r target/*'