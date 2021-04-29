#!/bin/sh

apt-get update
apt-get install postgresql-client php -y
apt-get update
ss -nlt
ufw allow from any to any port 5432 proto tcp