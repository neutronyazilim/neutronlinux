#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/sed" ] && { echo "sed zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$SED_SRC" ] || tar -xf "$SOURCES/$SED_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$SED_SRC"

BUILD_TRIPLET="$(build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"

make
make DESTDIR="$LFS" install

touch "$STAMPS/sed"
echo "sed hazir"
