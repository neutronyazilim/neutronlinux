#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/boost" ] && { echo "boost zaten kurulmus, atlaniyor"; exit 0; }

mkdir -p "$LFS/usr/include"
tar -xzf "$SOURCES/$BOOST_SRC.tar.gz" -C "$LFS/usr/include" \
    --strip-components=1 "$BOOST_SRC/boost"

touch "$STAMPS/boost"
echo "boost hazir"
