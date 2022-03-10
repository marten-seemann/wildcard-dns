FROM golang:1.17-alpine

RUN apk add git
RUN git clone https://github.com/coredns/coredns --branch v1.9.0 --single-branch /coredns
WORKDIR /coredns
RUN go get github.com/marten-seemann/coredns-multiaddr github.com/cloud66-oss/coredns_mysql
# The order of the plugins matters!
RUN echo "multiaddr:github.com/marten-seemann/coredns-multiaddr" >> plugin.cfg
RUN echo "mysql:github.com/cloud66-oss/coredns_mysql" >> plugin.cfg
RUN go generate
RUN go build -o coredns

FROM alpine:latest

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x wait-for-it.sh

RUN apk add bind-tools curl bash mysql-client mariadb-connector-c
COPY --from=0 /coredns/coredns /
ADD start.sh setup.sql.tmpl Corefile.tmpl /
RUN chmod +x start.sh

ENTRYPOINT [ "/start.sh" ]
