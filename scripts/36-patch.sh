#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/patch" ] && { echo "patch zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$PATCH_SRC" ] || tar -xf "$SOURCES/$PATCH_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$PATCH_SRC"

BUILD_TRIPLET="$(build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"

make
make DESTDIR="$LFS" install

touch "$STAMPS/patch"
echo "patch hazir"
