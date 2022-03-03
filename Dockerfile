FROM golang:1.17-alpine

RUN go install github.com/coredns/coredns@v1.9.0

FROM alpine:latest

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x wait-for-it.sh

RUN apk add bind-tools curl bash
COPY --from=0 /go/bin/coredns /
ADD start.sh /
RUN chmod +x start.sh
ADD Corefile.tmpl /

ENTRYPOINT [ "/start.sh" ]
