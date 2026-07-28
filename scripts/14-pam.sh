#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/pam" ] && { echo "PAM zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/libxcrypt" ] || { echo "once scripts/12-libxcrypt.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$PAM_SRC" ] || tar -xf "$SOURCES/$PAM_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$PAM_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr --libdir=/usr/lib \
    CC="$TARGET-gcc" \
    --disable-static --disable-doc --disable-examples \
    --disable-audit --disable-nis --disable-selinux

make
make DESTDIR="$LFS" install

touch "$STAMPS/pam"
echo "PAM hazir"
