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
        wget unzip
COPY    ./requirements/wordpress/conf /var/www/
RUN     sh /var/www/get_wordpress.sh
RUN     sh /var/www/setup_wordpress.sh && chmod 777 /var/www/wp-content/
CMD     [ "php-fpm82", "-F" ]