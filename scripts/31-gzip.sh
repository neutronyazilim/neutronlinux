#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/gzip" ] && { echo "gzip zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$GZIP_SRC" ] || tar -xf "$SOURCES/$GZIP_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$GZIP_SRC"

BUILD_TRIPLET="$(build-aux/config.guess 2>/dev/null || ./config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"

make
make DESTDIR="$LFS" install

touch "$STAMPS/gzip"
echo "gzip hazir"
