#!/bin/sh

sed "s/<domain>/$DOMAIN/g" Corefile.tmpl | sed "s/<mysql-root-pw>/$MYSQL_ROOT_PASSWORD/g" > Corefile
sed "s/<domain>/$DOMAIN/g" setup.sql.tmpl | sed "s/<soa>/$SOA/g" | sed "s/<ns>/$NAMESERVER_IP/g" > setup.sql

/wait-for-it.sh mysql:3306 -t 30

mysql -h mysql -u root -p"$MYSQL_ROOT_PASSWORD" < ./setup.sql

/coredns
