#!/bin/sh
set -euo pipefail

get_key(){
    tar -tvz        \
        --wildcards \
        -f "$1"     \
        *.pub       \
    | awk '{print $6}'
}

apk=$(readlink -f "$1"); shift;
pk=$(readlink -f "$1"); shift;
key_old=$(get_key "$apk")

tmpdir=$(mktemp -d)
cd "$tmpdir"

abuild-gzsplit < "$apk"
abuild-sign --private "$pk" control.tar.gz
cat control.tar.gz data.tar.gz > "$apk".tmp
mv "$apk".tmp "$apk"
apk verify "${apk}"
key_new=$(get_key "$apk")

rm -rf "$tmpdir"

printf "%s got sign %s replaced with %s\n" $apk $key_old $key_new
