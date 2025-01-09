
#!/bin/bash

set -x
set -e
DATADIR=$(jetpack config cyclecloud.mounts.db.mountpoint)
# Move the MySQL data directory to the block device
rsync -av /var/lib/mysql $DATADIR

if [ -d /var/lib/mysql.bak ]; then
    rm -rf /var/lib/mysql.bak
fi
mv /var/lib/mysql /var/lib/mysql.bak
mkdir -p /var/lib/mysql

# Set Correct Permissions
chown -R mysql:mysql $DATADIR/mysql
chmod 750 $DATADIR/mysql

# Update MySQL configuration
# Update datadir to use block device
sed -i "s|^#*\s*datadir.*|datadir = $DATADIR/mysql|" /etc/mysql/mysql.conf.d/mysqld.cnf
# Allow remote connections. Root user remote connection will be restricted to localhost using mysql commands.
sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
echo "alias /var/lib/mysql/ -> $DATADIR/mysql/," | sudo tee -a /etc/apparmor.d/tunables/alias

systemctl restart apparmor

systemctl start mysql