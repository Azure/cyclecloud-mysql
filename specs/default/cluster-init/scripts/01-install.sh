
#!/bin/bash

set -x
set -e
DATADIR=$(jetpack config cyclecloud.mounts.db.mountpoint)
# Move the MySQL data directory to the block device

mkdir -p $DATADIR/mysql
# Set Correct Permissions
chown -R mysql:mysql $DATADIR/mysql

/usr/sbin/mysqld --initialize-insecure --user=mysql --datadir=$DATADIR/mysql
systemctl start mysql
