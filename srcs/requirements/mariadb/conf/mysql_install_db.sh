#!/bin/sh

mkdir /var/run/mysqld
chmod 777 /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
sed -i -e "s@skip-networking@skip-networking=0@" -e "s@#bind-address=0.0.0.0@bind-address=0.0.0.0@" /etc/my.cnf.d/mariadb-server.cnf
mysql_install_db --user=mysql --ldata=/var/lib/mysql