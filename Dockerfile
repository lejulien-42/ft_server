# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lejulien <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/12/30 16:48:12 by lejulien          #+#    #+#              #
#    Updated: 2020/01/10 04:53:04 by lejulien         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
#Nginx Dockerfile
#
# Maintainer: Arjen de Vries [arjen@competa.com]

# Base image to use.
FROM debian:buster

# Install Nginx
RUN apt-get update
ADD ./srcs/wordpress /etc/nginx/sites-available/wordpress
RUN apt-get install -y nginx wget mariadb-server mariadb-client php-fpm php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl

COPY ./srcs/index.html /usr/share/nginx/html/

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN cd /tmp
RUN wget "https://fr.wordpress.org/latest-fr_FR.tar.gz"
RUN tar -xvf latest-fr_FR.tar.gz

RUN mv wordpress /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress/
RUN chmod -R 755 /var/www/html/wordpress/
RUN ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
ADD srcs/wp-config.php /var/www/html/wordpress/wp-config.php

# set the working dir
WORKDIR /etc/nginx

#define the default command
ENTRYPOINT ["nginx"]


COPY ./srcs/index.html /etc/nginx/html/
