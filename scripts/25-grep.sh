#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/grep" ] && { echo "grep zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$GREP_SRC" ] || tar -xf "$SOURCES/$GREP_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$GREP_SRC"

BUILD_TRIPLET="$(build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"

make
make DESTDIR="$LFS" install

touch "$STAMPS/grep"
echo "grep hazir"
