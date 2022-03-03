FROM golang:1.17-alpine

RUN go install github.com/coredns/coredns@v1.9.0

FROM alpine:latest

RUN apk add bind-tools
COPY --from=0 /go/bin/coredns /
ADD start.sh /
RUN chmod +x start.sh
ADD Corefile.tmpl /

ENTRYPOINT [ "/start.sh" ]
