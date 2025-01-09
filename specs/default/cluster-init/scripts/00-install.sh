#!/bin/bash

set -x
set -e

apt update
apt install -y mysql-server
# Stop the MySQL service
systemctl stop mysql