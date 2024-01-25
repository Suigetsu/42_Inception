# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mlagrini <mlagrini@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/22 15:41:06 by mlagrini          #+#    #+#              #
#    Updated: 2024/01/23 17:24:14 by mlagrini         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM    alpine:3.18
RUN     apk update && apk upgrade && apk add --no-cache php82 php82-fpm \
        php82-mysqli php82-json php82-curl php82-dom php82-exif \
        php82-fileinfo php82-mbstring php82-openssl php82-xml php82-zip \
        php82-redis wget unzip
RUN     mkdir /var/www/ && cd /var/www/ && wget https://wordpress.org/latest.zip && \
        unzip latest.zip && \
        cp -rf wordpress/* . && \
        rm -rf wordpress latest.zip
CMD     [ "yes" ]