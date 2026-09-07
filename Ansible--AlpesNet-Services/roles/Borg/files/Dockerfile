FROM alpine:3.20

# borgbackup: the tool itself
# bash: our entrypoint script needs it
# tzdata: correct timestamps in archive names/logs
RUN apk add --no-cache \
        borgbackup \
        bash \
        docker-cli \
        tzdata

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

WORKDIR /

ENTRYPOINT ["/usr/local/bin/backup.sh"]
