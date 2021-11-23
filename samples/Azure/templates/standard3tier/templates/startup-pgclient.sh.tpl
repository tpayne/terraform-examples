#!/bin/sh

echo 'Install Updates'
apt-get update

echo 'Configure firewall'
ss -nlt
ufw allow from any to any port 5432 proto tcp
ufw allow ssh
ufw status

