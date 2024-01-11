# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mlagrini <mlagrini@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/05 12:43:28 by mlagrini          #+#    #+#              #
#    Updated: 2024/01/09 18:18:32 by mlagrini         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM    alpine:3.16
RUN     apk update && apk upgrade && apk add --no-cache mariadb-server mariadb-client
RUN     mkdir -p /var/lib/mysql