
FROM debian:buster

LABEL maintainer="Jraye"

WORKDIR /var/www/html/

RUN apt update && \
	apt upgrade -y && \
	apt install -y vim nginx wget mariadb-server \
	php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring php-xml

RUN rm -rf /var/lib/apt/lists/*

# WORDPRESS
RUN wget http://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz && rm -f latest.tar.gz

# PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0-rc2/phpMyAdmin-5.1.0-rc2-all-languages.tar.gz && \
	tar -xzvf phpMyAdmin-5.1.0-rc2-all-languages.tar.gz && \
	rm -f phpMyAdmin-5.1.0-rc2-all-languages.tar.gz && \
	mv phpMyAdmin-5.1.0-rc2-all-languages phpmyadmin

# PHPMYADMIN config
RUN rm -f phpmyadmin/config.sample.inc.php
COPY ./srcs/config.inc.php phpmyadmin/config.inc.php

RUN openssl req -x509 -nodes -days 365 -subj \
	"/C=RU/ST=Russia/L=Moscow/O=CAO/OU=Moscow21/CN=me" \
	-newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt

# NGINX config
RUN rm -f /etc/nginx/sites-available/default
COPY ./srcs/nginx.conf /etc/nginx/sites-available/nginx.conf
RUN rm -f /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
RUN rm -f index.nginx-debian.html

# WORDPRESS config
RUN rm -f wordpress/wp-config-sample.php
COPY ./srcs/wp-config.php wordpress/wp-config.php

RUN chown -R www-data:www-data /var/www/html/

COPY ./srcs/start_db.sh /var/www/scripts/start_db.sh
COPY ./srcs/start_db.sql /var/www/scripts/start_db.sql
COPY ./srcs/autoindex_on.sh /var/www/scripts/autoindex_on.sh
COPY ./srcs/autoindex_off.sh /var/www/scripts/autoindex_off.sh


EXPOSE 80 443

ENTRYPOINT sh /var/www/scripts/start_db.sh
