#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libxml2" ] && { echo "libxml2 zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LIBXML2_SRC" ] || tar -xf "$SOURCES/$LIBXML2_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBXML2_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static --without-python CC="$TARGET-gcc"
make -j"$JOBS"
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libxml2"
echo "libxml2 hazir"
