#!/bin/sh

apt-get update
apt-get install -y apache2 libapache2-mod-php nginx net-tools -y
apt-get update

ifconfig
chown -R www-data:www-data /var/lib/nginx

cd /etc/nginx
nginx -g daemon off;