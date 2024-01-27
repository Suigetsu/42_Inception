# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mlagrini <mlagrini@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/22 15:41:06 by mlagrini          #+#    #+#              #
#    Updated: 2024/01/25 10:00:50 by mlagrini         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM    alpine:3.18
ARG     MYSQL_NAME MYSQL_USER MYSQL_PASSWORD MYSQL_ROOT_PASSWORD
RUN     apk update && apk upgrade && apk add --no-cache php82 php82-fpm \
        php82-mysqli php82-json php82-curl php82-dom php82-exif \
        php82-fileinfo php82-mbstring php82-openssl php82-xml php82-zip \
        php82-redis wget unzip
RUN     mkdir /var/www/ && cd /var/www/ && wget https://wordpress.org/latest.zip && \
        unzip latest.zip && cp -rf wordpress/* . && rm -rf wordpress latest.zip
RUN     sed -i "s@listen 127.0.0.1:9000@listen 9000@" /etc/php82/php-fpm.d/www.conf && \
        sed -i "s@;listen.owner = nobody@listen.owner = nobody@" /etc/php82/php-fpm.d/www.conf && \
        sed -i "s@;listen.group = nobody@listen.group = nobody@" /etc/php82/php-fpm.d/www.conf
COPY    ./requirements/wordpress/conf /var/www/
RUN     sh /var/www/setup_wordpress.sh && rm /var/www/setup_wordpress.sh && chmod -R 0777 /var/www/wp-content/
CMD     [ "php-fpm82" "-F" ]
# CMD     [ "yes" ]