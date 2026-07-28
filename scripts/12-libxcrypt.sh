#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libxcrypt" ] && { echo "libxcrypt zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LIBXCRYPT_SRC" ] || tar -xf "$SOURCES/$LIBXCRYPT_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBXCRYPT_SRC"

BUILD_TRIPLET="$(sh ./build-aux/m4-autogen/config.guess)"
./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" \
    --disable-static --enable-obsolete-api=no

make
make DESTDIR="$LFS" install

touch "$STAMPS/libxcrypt"
echo "libxcrypt hazir"
