#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kmod" ] && { echo "kmod zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$KMOD_SRC" ] || tar -xf "$SOURCES/$KMOD_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$KMOD_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr --sysconfdir=/etc \
    CC="$TARGET-gcc" \
    --disable-static --with-zlib=no --with-xz=no --with-zstd=no --with-openssl=no

make
make DESTDIR="$LFS" install

touch "$STAMPS/kmod"
echo "kmod hazir"
