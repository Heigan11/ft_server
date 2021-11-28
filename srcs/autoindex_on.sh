#!/bin/bash
sed -i "21s/off/on/g" /etc/nginx/sites-available/nginx.conf
service nginx reload;
