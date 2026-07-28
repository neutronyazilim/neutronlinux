#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/xz" ] && { echo "xz zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$XZ_SRC" ] || tar -xf "$SOURCES/$XZ_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$XZ_SRC"

BUILD_TRIPLET="$(build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc" \
    --disable-doc

make
make DESTDIR="$LFS" install

touch "$STAMPS/xz"
echo "xz hazir"
