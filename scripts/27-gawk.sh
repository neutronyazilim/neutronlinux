#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/gawk" ] && { echo "gawk zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$GAWK_SRC" ] || tar -xf "$SOURCES/$GAWK_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$GAWK_SRC"

BUILD_TRIPLET="$(build-aux/config.guess 2>/dev/null || ./config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"

make
make DESTDIR="$LFS" install

touch "$STAMPS/gawk"
echo "gawk hazir"
