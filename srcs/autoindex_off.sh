#!/bin/bash
sed -i "21s/on/off/g" /etc/nginx/sites-available/nginx.conf
service nginx reload;
