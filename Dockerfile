FROM golang:1.17-alpine

RUN apk add git
RUN git clone https://github.com/coredns/coredns --branch v1.9.0 --single-branch /coredns
WORKDIR /coredns
RUN go get github.com/coredns/records
RUN echo "records:github.com/coredns/records" >> plugin.cfg
RUN go generate
RUN go build -o coredns

FROM alpine:latest

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x wait-for-it.sh

RUN apk add bind-tools curl bash
COPY --from=0 /coredns/coredns /
ADD start.sh /
RUN chmod +x start.sh
ADD Corefile.tmpl /

ENTRYPOINT [ "/start.sh" ]
