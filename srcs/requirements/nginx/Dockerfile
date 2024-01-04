# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mlagrini <mlagrini@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/02 15:09:40 by mlagrini          #+#    #+#              #
#    Updated: 2024/01/04 14:57:17 by mlagrini         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM    alpine:3.16
RUN     apk update && apk upgrade && apk add --no-cache nginx
EXPOSE  443
CMD     ["nginx", "-g", "daemon off;"]