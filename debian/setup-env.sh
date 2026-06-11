#!/bin/bash
set -e

if [ -f "/apt/${REPO_NAME}/Packages" ]; then
    echo "deb [trusted=yes arch=${TARGET_ARCH}] file:///apt stable/" \
        > /etc/apt/sources.list.d/cartesi-apt.list
    [ -f "/apt/keys/${KEY_NAME}.gpg" ] && \
        gpg --dearmor -o /etc/apt/trusted.gpg.d/${KEY_NAME}.gpg \
            < "/apt/keys/${KEY_NAME}.gpg" || true
fi

if wget -qO /etc/apt/trusted.gpg.d/${KEY_NAME}.gpg "${REPO_URL}/keys/${KEY_NAME}.gpg.bin"; then
    echo "deb [arch=${TARGET_ARCH},all signed-by=/etc/apt/trusted.gpg.d/${KEY_NAME}.gpg] ${REPO_URL} stable/" \
        >> /etc/apt/sources.list.d/cartesi-apt.list
fi

apt-get update \
    -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/cartesi-apt.list \
    -o Dir::Etc::sourceparts=- \
    -o APT::Get::List-Cleanup=0 2>/dev/null || true

exec "$@"
