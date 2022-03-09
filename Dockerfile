FROM golang:1.17-alpine

RUN apk add git
RUN git clone https://github.com/coredns/coredns --branch v1.9.0 --single-branch /coredns
WORKDIR /coredns
RUN go get github.com/marten-seemann/coredns-multiaddr
RUN go get github.com/coredns/records
RUN go get github.com/cloud66-oss/coredns_mysql
RUN echo "multiaddr:github.com/marten-seemann/coredns-multiaddr" >> plugin.cfg
RUN echo "records:github.com/coredns/records" >> plugin.cfg
RUN echo "mysql:github.com/cloud66-oss/coredns_mysql" >> plugin.cfg
RUN go generate
RUN go build -o coredns

FROM alpine:latest

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x wait-for-it.sh

RUN apk add bind-tools curl bash mysql-client mariadb-connector-c
COPY --from=0 /coredns/coredns /
ADD start.sh setup.sql /
RUN chmod +x start.sh
ADD Corefile.tmpl /

ENTRYPOINT [ "/start.sh" ]
