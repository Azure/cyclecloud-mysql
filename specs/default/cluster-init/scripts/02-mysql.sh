#!/bin/bash

set -x
set -e

USERNAME=$(jetpack config database.user)
PASSWORD=$(jetpack config database.password)

mysql -u root <<EOF
DROP USER IF EXISTS '$USERNAME'@'%';
CREATE USER '$USERNAME'@'%' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$USERNAME'@'%' WITH GRANT OPTION;
# Run mysql_secure_installation non-interactively
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;

EOF