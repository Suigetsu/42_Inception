# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mlagrini <mlagrini@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/05 12:43:28 by mlagrini          #+#    #+#              #
#    Updated: 2024/01/22 14:55:28 by mlagrini         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM        alpine:3.18
ARG         MYSQL_NAME MYSQL_USER MYSQL_PASSWORD MYSQL_ROOT_PASSWORD MYSQL_ROOT
RUN         apk update && apk upgrade && apk add mariadb mariadb-client
COPY        requirements/mariadb/conf/ .
RUN         sh mysql_install_db.sh
RUN         sh db_script.sh
CMD         [ "mysqld", "--user=mysql" ]