# mysql  backuper image
FROM alpine:3.2
MAINTAINER BetaCZ <hlj8080@gmail.com>

# install the mysql client
RUN apk add --update mysql-client  && rm -rf /var/cache/apk/*
# backup target
VOLUME /backups
# install the entrypoint
COPY ./run /usr/local/bin/run
COPY ./backup /etc/backup


# start
ENTRYPOINT ["/usr/local/bin/run"]
