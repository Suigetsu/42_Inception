# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mlagrini <mlagrini@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/25 12:03:40 by mlagrini          #+#    #+#              #
#    Updated: 2024/01/25 12:06:15 by mlagrini         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all:
	docker-compose -f ./docker-compose.yml up -d
build:
	docker-compose -f ./docker-compose.yml up -d --build
down:
	docker-compose -f ./docker-compose.yml down
