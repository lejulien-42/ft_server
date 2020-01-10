# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lejulien <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/12/30 16:48:12 by lejulien          #+#    #+#              #
#    Updated: 2020/01/10 05:30:40 by lejulien         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
#Nginx Dockerfile
#

# Base image to use.
FROM debian:buster
MAINTAINER lejulien "lejulien@student.42.fr"

# Install Nginx
RUN apt-get update
ADD ./srcs/wordpress /etc/nginx/sites-available/wordpress
RUN apt-get install -y nginx wget mariadb-server mariadb-client php-fpm php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl

COPY ./srcs/index.html /var/www/html/index.html

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN cd /tmp
RUN wget "https://fr.wordpress.org/latest-fr_FR.tar.gz"
RUN tar -xvf latest-fr_FR.tar.gz

RUN mv wordpress /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress/
RUN chmod -R 755 /var/www/html/wordpress/
RUN ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
ADD srcs/wp-config.php /var/www/html/wordpress/wp-config.php
RUN ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
# set the working dir
WORKDIR /etc/nginx

#define the default command
ENTRYPOINT ["nginx"]


COPY ./srcs/index.html /etc/nginx/html/
