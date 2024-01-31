#!/bin/sh

mkdir /var/run/mysqld
chmod 777 /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
cat << EOF > /etc/my.cnf.d/docker.cnf
[mysqld]
skip-host-cache
skip-name-resolve
bind-address=0.0.0.0
EOF
sed -i "s@skip-networking@skip-networking=0@" /etc/my.cnf.d/mariadb-server.cnf
mysql_install_db --user=mysql --ldata=/var/lib/mysql