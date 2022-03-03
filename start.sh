#!/bin/sh

# coredns doesn't like unresolved hostnames in forward directives
# resolve the IP address that Docker assigned to the powerdns container now
sed "s/<coredns>/$(dig +short powerdns)/g" Corefile.tmpl > Corefile

/coredns
