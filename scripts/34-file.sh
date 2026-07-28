#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/file" ] && { echo "file zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$FILE_SRC" ] || tar -xf "$SOURCES/$FILE_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$FILE_SRC"

if [ ! -x native-build/src/file ]; then
    rm -rf native-build
    mkdir native-build
    (cd native-build && ../configure CC=gcc-15 && make)
fi

BUILD_TRIPLET="$(./config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"
make FILE_COMPILE="$PWD/native-build/src/file"
make DESTDIR="$LFS" install FILE_COMPILE="$PWD/native-build/src/file"

touch "$STAMPS/file"
echo "file hazir"
