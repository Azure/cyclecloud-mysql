#!/bin/bash

set -x
set -e


USERNAME=$(jetpack config database.user)
PASSWORD=$(jetpack config database.password)
DATADIR=$(jetpack config cyclecloud.mounts.db.mountpoint)
apt update
apt install -y mysql-server
# Stop the MySQL service
systemctl stop mysql

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

mysql -u root <<EOF

CREATE USER '$USERNAME'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
# Run mysql_secure_installation non-interactively
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;

EOF
