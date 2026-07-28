#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/expat" ] && { echo "expat zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$EXPAT_SRC" ] || tar -xf "$SOURCES/$EXPAT_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$EXPAT_SRC"

BUILD_TRIPLET="$(sh ./conftools/config.guess 2>/dev/null || sh ./config.guess)"
./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" \
    --disable-static --without-docbook --without-tests --without-examples

make
make DESTDIR="$LFS" install

touch "$STAMPS/expat"
echo "expat hazir"
