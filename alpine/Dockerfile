ARG BASE_IMAGE=alpine
FROM ${BASE_IMAGE}

# Install build essential
RUN apk update && \
    apk upgrade && \
    apk add alpine-sdk wget

# List local apk repository
RUN echo /root/packages/work >> /etc/apk/repositories && \
    adduser -D builder

COPY --chmod=755 re-sign-apk.sh /usr/local/bin/
COPY --chmod=755 build-apk.sh   /usr/local/bin/
COPY --chmod=755 setup-env.sh   /usr/local/bin/

WORKDIR /work
