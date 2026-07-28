#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/which" ] && { echo "which zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$WHICH_SRC" ] || tar -xf "$SOURCES/$WHICH_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$WHICH_SRC"

BUILD_TRIPLET="$(sh ./config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"

make
make DESTDIR="$LFS" install

touch "$STAMPS/which"
echo "which hazir"
