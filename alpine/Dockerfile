# syntax=docker.io/docker/dockerfile:1

ARG BASE_IMAGE=docker.io/alpine@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 # v3.24.0
FROM ${BASE_IMAGE}

# Install build essential
RUN <<EOF
set -eu
apk update
apk add alpine-sdk wget
EOF

# List local apk repository
RUN echo /root/packages/work >> /etc/apk/repositories && \
    adduser -D builder

COPY --chmod=755 re-sign-apk.sh /usr/local/bin/
COPY --chmod=755 build-apk.sh   /usr/local/bin/
COPY --chmod=755 setup-env.sh   /usr/local/bin/

WORKDIR /work
