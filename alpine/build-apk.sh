#!/bin/sh
set -e

. ./APKBUILD

pkgfile="${pkgname}-${pkgver}-r${pkgrel}.apk"

if find "/root/packages/work/${TARGET_ARCH}" -name "${pkgfile}" | grep -q .; then
    echo "${pkgname}: Package is up to date (${pkgver}-r${pkgrel})"
    exit 0
fi

export SOURCE_DATE_EPOCH=$(stat -c %Y APKBUILD)
abuild -rF
