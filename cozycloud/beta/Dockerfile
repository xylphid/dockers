#FROM nginx:1.13.9-alpine
# FROM alpine:3.7
FROM golang:1.10.0-alpine3.7 as builder

# Install dependencies
RUN apk add --no-cache git && \
    go get -u github.com/cozy/cozy-stack

FROM alpine:3.7

ARG VERSION
ENV VERSION     ${VERSION:-build}

LABEL maintainer.name="Anthony PERIQUET"
LABEL maintainer.email="anthony@periquet.net"
LABEL version=${VERSION}
LABEL description="Cozy-Cloud Core"

ENV COZY_ADMIN_PASSWORD     "password"
ENV COZY_APPS               "drive,photos,collect,settings"
ENV COZY_DOMAIN             "mycozy.tld"

ENV COZY_PORT               "8080"
ENV COZY_ADMIN_HOST         "0.0.0.0"
ENV COZY_ADMIN_PORT         "6060"
ENV COZY_ADMIN_PASSPHRASE   "XXX"
ENV COZY_COUCHDB_URL        "http://couchdb:5984"
ENV COZY_MAIL_REPLY         "noreply@localhost"
ENV COZY_MAIL_REPLY_NAME    "noreply@localhost"
ENV COZY_SMTP_HOST          ""
ENV COZY_SMTP_PORT          "465"
ENV COZY_SMTP_USERNAME      ""
ENV COZY_SMTP_PASSWORD      ""
ENV COZY_SMTP_TLS_ENABLE    "false"

COPY --from=builder /go/bin/cozy-stack /tmp/cozy-stack

RUN apk add --no-cache \
        curl \
        git \
        imagemagick \
        rsyslog && \
    install -m0755 -o root -g root /tmp/cozy-stack /usr/bin/cozy-stack && \
    # Clean temporary folder
    rm -f /tmp/cozy-stack && \
    adduser -h /cozy -s /bin/sh -D cozy && \
    install -d -o cozy -g cozy /etc/cozy /var/datas/

# Copy configuration template
COPY config/cozy.yml /etc/cozy/

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

VOLUME /var/datas

ENTRYPOINT [ "docker-entrypoint.sh" ]