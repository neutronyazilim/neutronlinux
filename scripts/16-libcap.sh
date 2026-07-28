#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libcap" ] && { echo "libcap zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LIBCAP_SRC" ] || tar -xf "$SOURCES/$LIBCAP_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBCAP_SRC"

make CROSS_COMPILE="$TARGET-" BUILD_CC=gcc-15 GOLANG=no PAM_CAP=no \
    prefix=/usr lib=lib SHARED=yes

make CROSS_COMPILE="$TARGET-" BUILD_CC=gcc-15 GOLANG=no PAM_CAP=no \
    prefix=/usr lib=lib SHARED=yes DESTDIR="$LFS" install

touch "$STAMPS/libcap"
echo "libcap hazir"
