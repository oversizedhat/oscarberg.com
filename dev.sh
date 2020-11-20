#!/bin/sh
export DEV_SERVER_PRIVATE_IP=$(hostname -I | awk '{print $1}')
exec docker-compose up