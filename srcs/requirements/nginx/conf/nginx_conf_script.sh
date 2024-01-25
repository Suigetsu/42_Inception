#!/bin/sh

cat << EOF > /etc/nginx/http.d/nginx.conf
server {
    listen      443 ssl;
    server_name  ${DOMAIN_NAME} www.${DOMAIN_NAME};
    root    /var/www/;
    index index.php index.html;
    ssl_certificate     ${SSL_CERT};
    ssl_certificate_key ${SSL_KEY};
    ssl_protocols       TLSv1.2 TLSv1.3;
    location / {
        try_files ${DOLLAR_SIGN}uri /index.php?${DOLLAR_SIGN}args /index.html;
        # add_header Last-Modified ${DOLLAR_SIGN}date_gmt;
        add_header Cache-Control 'no-store, no-cache';
        # if_modified_since off;
        # expires off;
        # etag off;
    }
}
EOF
