# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mlagrini <mlagrini@student.1337.ma>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/02 15:09:40 by mlagrini          #+#    #+#              #
#    Updated: 2024/01/25 09:03:32 by mlagrini         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM        alpine:3.18
ARG         DOMAIN_NAME SSL_CERT SSL_KEY DOLLAR_SIGN
RUN         apk update && apk upgrade && apk add --no-cache nginx
COPY        requirements/nginx/conf/nginx_conf_script.sh .
RUN         sh nginx_conf_script.sh
CMD         [ "nginx", "-g", "daemon off;" ]