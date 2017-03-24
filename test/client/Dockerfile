FROM alpine:3.5

RUN apk add --update curl

ADD client.sh /client.sh

ENTRYPOINT /bin/sh /client.sh

