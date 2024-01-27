#!/bin/sh

if [ ! -f "/var/www/wp-config.php" ]; then
    cat << EOF > /var/www/wp-config.php
<?php
define( 'MYSQL_NAME', '${MYSQL_NAME}' );
define( 'MYSQL_USER', '${MYSQL_USER}' );
define( 'MYSQL_PASSWORD', '${MYSQL_PASSWORD}' );
define( 'MYSQL_HOST', 'mariadb' );
define( 'MYSQL_CHARSET', 'utf8' );
define( 'MYSQL_COLLATE', '' );
define('FS_METHOD','direct');
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );}
require_once ABSPATH . 'wp-settings.php';
EOF
fi