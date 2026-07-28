#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/qt5compat" ] && { echo "qt5compat zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/qtbase" ] || { echo "once scripts/58-qtbase.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$QT5COMPAT_SRC" ] || tar -xf "$SOURCES/$QT5COMPAT_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$QT5COMPAT_SRC"

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

touch "$STAMPS/qt5compat"
echo "qt5compat hazir"
