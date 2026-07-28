#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libpng" ] && { echo "libpng zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/zlib" ] || { echo "once zlib icin ilgili scripti calistirin" >&2; exit 1; }

[ -d "$BUILD/$LIBPNG_SRC" ] || tar -xf "$SOURCES/$LIBPNG_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBPNG_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess 2>/dev/null || sh ./scripts/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static CC="$TARGET-gcc"
make
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libpng"
echo "libpng hazir"
