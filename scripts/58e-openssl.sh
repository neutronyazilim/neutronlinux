#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/openssl" ] && { echo "openssl zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$OPENSSL_SRC" ] || tar -xf "$SOURCES/$OPENSSL_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$OPENSSL_SRC"

./Configure linux-x86_64 \
    --prefix=/usr --openssldir=/etc/ssl --libdir=lib \
    CC="$TARGET-gcc" \
    shared no-tests no-docs

make
make DESTDIR="$LFS" install_sw install_ssldirs

touch "$STAMPS/openssl"
echo "openssl hazir"
