#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/strace" ] && { echo "strace zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$STRACE_SRC" ] || tar -xf "$SOURCES/$STRACE_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$STRACE_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" --enable-static=no --enable-mpers=no \
    --disable-gcc-Werror
make
make DESTDIR="$LFS" install

touch "$STAMPS/strace"
echo "strace hazir"
