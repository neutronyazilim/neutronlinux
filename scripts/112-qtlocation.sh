#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/qtlocation" ] && { echo "qtlocation zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/qtpositioning" ] || { echo "once scripts/109-qtpositioning.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$QTLOCATION_SRC" ] || tar -xf "$SOURCES/$QTLOCATION_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$QTLOCATION_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DQT_BUILD_EXAMPLES=OFF \
    -DQT_BUILD_TESTS=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/qtlocation"
echo "qtlocation hazir"
