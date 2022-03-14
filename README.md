# wildcard-dns

A DNS server that
1. resolves `<ip-multiaddr>.domain.tld` (and `<ip-multiaddr>.subdomain.domain.tld`) to `<ip>`.
2. allows the programmatic setting of DNS records, especially (but not limited to) TXT records used in ACME challenges.

The project builds on top of [CoreDNS](https://github.com/coredns/coredns) and uses the [MySQL plugin](https://coredns.io/explugins/mysql/) as a storage backend (with [two](https://github.com/cloud66-oss/coredns_mysql/pull/5) [bug](https://github.com/cloud66-oss/coredns_mysql/pull/6) fixes).

Records can be added / modified by adding / updating entries in the database. For security reasons, this is only posible from localhost by default, but this could easily be changed by exposing the MySQL port from the `mysql` Docker container.

## Buiding and Running

Build:
```sh
docker-compose build
```

The docker-compose config uses a few environment variables. It is recommended to define them in a [`.env` file](https://docs.docker.com/compose/environment-variables/#the-env-file):
* `DOMAIN`: the top-level domain we're resolving
* `NAMESERVER_IP`: the IP address of the nameserver (i.e. the public IP this server is listening on)
* `MYSQL_ROOT_PASSWORD`: a password for the MySQL server

Run:
```sh
docker-compose up
```
