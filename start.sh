#!/bin/sh

# escape . in the domain name with a \
domain_escaped=$(echo "$DOMAIN" | sed "s/\./\\\\\\\./g")
timestamp=$(date +%s)

# coredns doesn't like unresolved hostnames in forward directives
# resolve the IP address that Docker assigned to the powerdns container now
sed "s/<powerdns>/$(dig +short powerdns)/g" Corefile.tmpl | sed "s/<domain_escaped>/$domain_escaped/g" | sed "s/<domain>/$DOMAIN/g" | sed "s/<timestamp>/$timestamp/g" | sed "s/<soa>/$SOA/g" | sed "s/<nameserver-ip>/$NAMESERVER_IP/g" | sed "s/<mysql-root-pw>/$MYSQL_ROOT_PASSWORD/g" > Corefile

/wait-for-it.sh mysql:3306 -t 30

mysql -h mysql -u root -p"$MYSQL_ROOT_PASSWORD" < ./setup.sql

/coredns
