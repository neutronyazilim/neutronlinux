#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/zstd" ] && { echo "zstd zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$ZSTD_SRC" ] || tar -xf "$SOURCES/$ZSTD_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$ZSTD_SRC/build/cmake"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DZSTD_BUILD_PROGRAMS=OFF \
    -DZSTD_BUILD_TESTS=OFF \
    -DZSTD_BUILD_STATIC=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/zstd"
echo "zstd hazir"
