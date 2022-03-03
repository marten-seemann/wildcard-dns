#!/bin/sh

# escape . in the domain name with a \
domain_escaped=$(echo "$DOMAIN" | sed "s/\./\\\\\\\./g")

# coredns doesn't like unresolved hostnames in forward directives
# resolve the IP address that Docker assigned to the powerdns container now
sed "s/<coredns>/$(dig +short powerdns)/g" Corefile.tmpl | sed "s/<domain_escaped>/$domain_escaped/g" | sed "s/<domain>/$DOMAIN/g" > Corefile

/wait-for-it.sh powerdns:8081 -t 30

timestamp=$(date +%s)
curl -X POST --data '{"name":"'$DOMAIN'.", "kind": "Master", "dnssec":false, "soa-edit":"'$timestamp'", "masters": [], "nameservers": ["ns1.'$DOMAIN'."]}' -s -H "X-API-Key: $APIKEY" http://powerdns:8081/api/v1/servers/localhost/zones

/coredns
