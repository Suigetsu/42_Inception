# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mlagrini <mlagrini@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/05 12:43:28 by mlagrini          #+#    #+#              #
#    Updated: 2024/01/15 18:54:05 by mlagrini         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine:3.16
RUN apk update && apk upgrade && apk add mariadb mariadb-client
RUN mkdir -p /var/run/msqld