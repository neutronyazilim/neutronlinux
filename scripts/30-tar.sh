#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/tar" ] && { echo "tar zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$TAR_SRC" ] || tar -xf "$SOURCES/$TAR_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$TAR_SRC"

BUILD_TRIPLET="$(build-aux/config.guess)"
FORCE_UNSAFE_CONFIGURE=1 ./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"

make
make DESTDIR="$LFS" install

touch "$STAMPS/tar"
echo "tar hazir"
