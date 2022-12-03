# mysql  backuper image
FROM alpine
MAINTAINER BetaCZ <hlj8080@gmail.com>

# install the mysql client
RUN apk add --update mysql-client openssl tzdata && rm -rf /var/cache/apk/*
# backup target
VOLUME /backups
# install the entrypoint
COPY ./run /usr/local/bin/run
COPY ./dump /usr/local/bin/dump
COPY ./decrypt /usr/local/bin/decrypt


# start
CMD ["/usr/local/bin/run"]

