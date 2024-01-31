#!/bin/sh

if [ ! -d "/var/lib/mysql/wordpress" ]; then
cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
CREATE DATABASE ${MYSQL_NAME};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED by '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
mysqld --user=mysql --bootstrap < /tmp/create_db.sql
fi
