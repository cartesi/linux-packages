#!/bin/bash
set -u

failed=""
for pkg in "$@"; do
    echo "=== Testing ${pkg} ==="
    case "$pkg" in
        cartesi-machine-emulator)
            apt-get install --no-install-recommends -y "$pkg" && cartesi-machine --final-hash
            ;;
        cartesi-machine-guest-tools)
            apt-get install --no-install-recommends -y "$pkg" && rollup --help
            ;;
        *)
            apt-get install --no-install-recommends -y "$pkg"
            ;;
    esac || failed="${failed} ${pkg}"
done

if [ -n "$failed" ]; then
    echo "FAILED package tests:${failed}"
    exit 1
fi
