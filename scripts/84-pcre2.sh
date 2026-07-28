#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/pcre2" ] && { echo "pcre2 zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$PCRE2_SRC" ] || tar -xf "$SOURCES/$PCRE2_SRC.tar.bz2" -C "$BUILD"
cd "$BUILD/$PCRE2_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static --enable-jit CC="$TARGET-gcc"
make
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/pcre2"
echo "pcre2 hazir"
