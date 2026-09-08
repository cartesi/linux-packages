#!/bin/sh
set -e

[ -f "/key/${KEY_NAME}.rsa" ] && \
    cp /key/*.rsa.pub /etc/apk/keys/ && \
    cp -a /key /root/.abuild && \
    chown -R root:root /root/.abuild || true

wget -q "${REMOTE_APK_REPO_URL}/keys/cartesi-apk-key.rsa.pub" \
    -O /etc/apk/keys/cartesi-apk-key.rsa.pub && \
    echo "${REMOTE_APK_REPO_URL}/stable" >> /etc/apk/repositories && \
    apk update -q || true

find /root/packages/work -name 'APKINDEX.tar.gz' -size -1000c -delete 2>/dev/null || true

exec "$@"
