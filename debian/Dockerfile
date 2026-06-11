ARG BASE_IMAGE=ubuntu:noble
FROM ${BASE_IMAGE} AS toolchain

# Install build essential
RUN apt-get update && \
    apt-get upgrade --no-install-recommends -y && \
    apt-get install --no-install-recommends -y \
        build-essential wget ca-certificates debhelper apt-utils gnupg sudo debmake gpg

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

WORKDIR /work
