#!/bin/sh
apt-get update
apt-get install curl ca-certificates gnupg -y
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list'
apt-get update
apt-get install postgresql-client-11 -y

ss -nlt
ufw allow from any to any port 5432 proto tcp
ufw allow ssh
ufw status


