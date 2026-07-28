#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/bash" ] && { echo "bash zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$BASH_SRC" ] || tar -xf "$SOURCES/$BASH_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$BASH_SRC"

BUILD_TRIPLET="$(sh ./support/config.guess)"
./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" CC_FOR_BUILD="gcc-15 -std=gnu17" \
    --without-bash-malloc

make
make DESTDIR="$LFS" install

touch "$STAMPS/bash"
echo "bash hazir: $LFS/usr/bin/bash"
file "$LFS/usr/bin/bash"
