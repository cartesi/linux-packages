# syntax=docker.io/docker/dockerfile:1

ARG BASE_IMAGE=docker.io/ubuntu:noble-20260509.1
FROM ${BASE_IMAGE} AS toolchain

# Install build essential
ARG APT_UPDATE_SNAPSHOT=20260601T030400Z
ARG DEBIAN_FRONTEND=noninteractive
RUN <<EOF
set -eu
apt-get update
apt-get install -y --no-install-recommends ca-certificates
apt-get update --snapshot=${APT_UPDATE_SNAPSHOT}
apt-get install --no-install-recommends -y \
    build-essential wget ca-certificates debhelper apt-utils gnupg sudo debmake gpg
EOF

# Install go
ARG GO_VERSION=1.26.0
ARG BUILDARCH
RUN wget -O /tmp/go.tar.gz "https://go.dev/dl/go${GO_VERSION}.linux-${BUILDARCH}.tar.gz" && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

COPY --chmod=755 build-deb.sh      /usr/local/bin/
COPY --chmod=755 gen-index.sh      /usr/local/bin/
COPY --chmod=755 sign-index.sh     /usr/local/bin/
COPY --chmod=755 setup-env.sh      /usr/local/bin/
COPY gen-key-batch.txt /usr/local/share/

# Install go
ARG GO_VERSION=1.26.0
ARG BUILDARCH
RUN wget -O /tmp/go.tar.gz "https://go.dev/dl/go${GO_VERSION}.linux-${BUILDARCH}.tar.gz" && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /work
