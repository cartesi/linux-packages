#!/bin/sh
set -e

wget -q "${REMOTE_APK_REPO_URL}/keys/cartesi-apk-key.rsa.pub" \
    -O /etc/apk/keys/cartesi-apk-key.rsa.pub && \
    echo "${REMOTE_APK_REPO_URL}/stable" >> /etc/apk/repositories && \
    apk update -q || true

[ -f "/key/${KEY_NAME}.rsa" ] && \
    cp /key/*.rsa.pub /etc/apk/keys/ && \
    cp -a /key /root/.abuild && \
    echo "PACKAGER_PRIVKEY=/root/.abuild/${KEY_NAME}.rsa" > /root/.abuild/abuild.conf && \
    chown -R root:root /root/.abuild || true

find /root/packages/work -name 'APKINDEX.tar.gz' -size -1000c -delete 2>/dev/null || true

exec "$@"
