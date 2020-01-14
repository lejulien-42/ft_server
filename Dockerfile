# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lejulien <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/12/30 16:48:12 by lejulien          #+#    #+#              #
#    Updated: 2020/01/12 16:17:46 by lejulien         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster
MAINTAINER lejulien "lejulien@student.42.fr"

# Install necesarly packages

RUN apt update
RUN apt install -y nginx wget curl lsb-release gnupg php-mysql php-mbstring php-zip php-gd mariadb-server
RUN apt-get update
RUN apt install php-fpm -y

# Prepare locals

RUN /etc/init.d/php7.3-fpm start
RUN mkdir /var/www/localhost
RUN rm /etc/nginx/sites-available/default
COPY ./srcs/index.php /var/www/localhost/index.php
ADD ./srcs/site /var/www/localhost/site

# Adding nginx conf file

ADD ./srcs/default.conf /etc/nginx/sites-available/default/default.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/default/default.conf /etc/nginx/sites-enabled/default.conf

# Allow rights

RUN chmod 755 /var/www/localhost

# Install phpmyadmin and wordpress

RUN cd /tmp
ADD ./srcs/phpmyadmin /var/www/localhost/phpmyadmin
ADD ./srcs/wordpress /var/www/localhost/wordpress
RUN chown -R www-data:www-data /var/www/localhost/wordpress
RUN find /var/www/localhost/wordpress/ -type d -exec chmod 750 {} \;
RUN find /var/www/localhost/wordpress/ -type f -exec chmod 640 {} \;
RUN cp /var/www/localhost/phpmyadmin/config.sample.inc.php /var/www/localhost/phpmyadmin/config.inc.php

# Installing ssl confirmation

RUN echo "Installing mkcert (for SSL)"
RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64
RUN mv mkcert-v1.4.1-linux-amd64 mkcert
RUN chmod +x mkcert
RUN echo "Setting up mkcert"
RUN ./mkcert -install
RUN ./mkcert localhost

# Run script for starting services

RUN service mysql start
COPY ./srcs/script.sh ./script.sh
ENTRYPOINT ["/bin/bash", "./script.sh"]
