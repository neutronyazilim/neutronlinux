#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libtool" ] && { echo "libtool zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LIBTOOL_SRC" ] || tar -xf "$SOURCES/$LIBTOOL_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBTOOL_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static CC="$TARGET-gcc"
make -j"$JOBS"
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libtool"
echo "libtool hazir"
