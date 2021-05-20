#!/bin/sh

ss -nlt
ufw allow from any to any port 5432 proto tcp
ufw allow ssh
ufw status

