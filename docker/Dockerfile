FROM alpine:latest

ENV HOST=DOMAIN_NAME \
    LOGIN=LOGIN \
    PASSWORD=PASSWORD

RUN addgroup dynhost \
  && adduser -G dynhost -D -H dynhost

RUN apk --no-cache add \
  curl \
  bind-tools

COPY dynhost.sh /usr/local/bin
USER dynhost

ENTRYPOINT ["/usr/local/bin/dynhost.sh"]
