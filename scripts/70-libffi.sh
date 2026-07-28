#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libffi" ] && { echo "libffi zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LIBFFI_SRC" ] || tar -xf "$SOURCES/$LIBFFI_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$LIBFFI_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr --libdir=/usr/lib \
    --disable-static --disable-multi-os-directory CC="$TARGET-gcc"
make
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libffi"
echo "libffi hazir"
