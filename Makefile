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

all: build

build:
	./srcs/requirements/tools/volumes_script.sh
	docker-compose -f srcs/docker-compose.yml up -d --build

down:
	docker-compose -f srcs/docker-compose.yml down

fclean: down
	docker system prune -a --volumes