#!/bin/sh

if [ ! -d "/var/www/wp-admin" ]; then
mkdir /var/www/
cd /var/www/
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -rf wordpress/* .
rm -rf wordpress latest.zip
fi
sed -i -e "s@listen = 127.0.0.1:9000@listen = 9000@" \
    -e "s@;listen.owner = nobody@listen.owner = nobody@" \
    -e "s@;listen.group = nobody@listen.group = nobody@" /etc/php82/php-fpm.d/www.conf