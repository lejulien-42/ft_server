# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lejulien <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/12/30 16:48:12 by lejulien          #+#    #+#              #
#    Updated: 2020/01/12 13:41:52 by lejulien         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
FROM debian:buster
MAINTAINER lejulien "lejulien@student.42.fr"
RUN apt update
RUN apt install -y nginx wget curl lsb-release gnupg php-mysql php-mbstring php-zip php-gd mariadb-server
RUN apt-get update
RUN apt install php-fpm -y
RUN /etc/init.d/php7.3-fpm start
RUN mkdir /var/www/localhost
RUN rm /etc/nginx/sites-available/default
COPY ./srcs/index.php /var/www/localhost/index.php
ADD ./srcs/default.conf /etc/nginx/sites-available/default/default.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/default/default.conf /etc/nginx/sites-enabled/default.conf
RUN chmod 755 /var/www/localhost
RUN cd /tmp
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN curl -O https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
RUN rm latest.tar.gz
RUN mv wordpress /var/www/localhost/wordpress
RUN chown -R www-data:www-data /var/www/localhost/wordpress
RUN find /var/www/localhost/wordpress/ -type d -exec chmod 750 {} \;
RUN find /var/www/localhost/wordpress/ -type f -exec chmod 640 {} \;
RUN tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.0.1-all-languages/ /var/www/localhost/phpmyadmin
RUN cp /var/www/localhost/phpmyadmin/config.sample.inc.php /var/www/localhost/phpmyadmin/config.inc.php
RUN service nginx reload
RUN service mysql start
COPY ./srcs/script.sh ./script.sh
ENTRYPOINT ["/bin/bash", "./script.sh"]
