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
ARG         MYSQL_NAME MYSQL_USER MYSQL_PASSWORD MYSQL_ROOT_PASSWORD 
RUN         apk update && apk upgrade && apk add mariadb mariadb-client
RUN         mkdir /var/run/mysqld && chmod 777 /var/run/mysqld && \
            chown -R mysql:mysql /var/run/mysqld
RUN         mysql_install_db --user=mysql --ldata=/var/lib/mysql
RUN         sed -i 's@#bind-address=0.0.0.0@bind-address=0.0.0.0@' \
            /etc/my.cnf.d/mariadb-server.cnf
EXPOSE      3306
COPY        requirements/mariadb/conf/db_script.sh .
RUN         sh db_script.sh
# ENTRYPOINT [ "sh", "-c", "db_script.sh" ]
CMD         [ "mysqld", "--user=mysql" ]