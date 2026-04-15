ARG BASE_IMAGE=alpine
FROM ${BASE_IMAGE}

# Install build essential
RUN apk update && \
    apk upgrade && \
    apk add alpine-sdk

# List local apk repository
RUN echo /root/packages/work >> /etc/apk/repositories && \
    adduser -D builder

COPY re-sign-apk.sh /usr/local/bin/

WORKDIR /work
