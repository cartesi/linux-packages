#!/bin/sh
set -u

failed=""
for pkg in "$@"; do
    echo "=== Testing ${pkg} ==="
    case "$pkg" in
        cartesi-machine-emulator)
            apk add --allow-untrusted "$pkg" && cartesi-machine --final-hash
            ;;
        cartesi-machine-guest-tools)
            apk add --allow-untrusted "$pkg" && rollup --help
            ;;
        *)
            apk add --allow-untrusted "$pkg"
            ;;
    esac || failed="${failed} ${pkg}"
done

if [ -n "$failed" ]; then
    echo "FAILED package tests:${failed}"
    exit 1
fi
