#!/bin/sh

if [ ! -d "/var/www/" ]; then
    mkdir /var/www/
    cd /var/www/
    wget https://wordpress.org/latest.zip
    unzip latest.zip
    cp -rf wordpress/* .
    rm -rf wordpress latest.zip
fi
sed -i "s@listen 127.0.0.1:9000@listen 9000@" /etc/php82/php-fpm.d/www.conf
sed -i "s@;listen.owner = nobody@listen.owner = nobody@" /etc/php82/php-fpm.d/www.conf
sed -i "s@;listen.group = nobody@listen.group = nobody@" /etc/php82/php-fpm.d/www.conf