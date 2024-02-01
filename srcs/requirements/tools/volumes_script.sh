#!/bin/bash
if [ ! -d "/home/mlagrini/data" ]; then
    mkdir -p ~/data/mariadb ~/data/wordpress
    chmod 777 ~/data/
    chmod 777 ~/data/mariadb
    chmod 777 ~/data/wordpress
fi