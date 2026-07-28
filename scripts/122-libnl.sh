#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libnl" ] && { echo "libnl zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LIBNL_SRC" ] || tar -xf "$SOURCES/$LIBNL_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$LIBNL_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static CC="$TARGET-gcc"
make -j"$JOBS"
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libnl"
echo "libnl hazir"
