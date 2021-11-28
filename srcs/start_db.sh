#!/bin/bash
service mysql start;
service php7.3-fpm start;
mysql -u root --skip-password < /var/www/scripts/start_db.sql;
service nginx start;
sleep infinity;
