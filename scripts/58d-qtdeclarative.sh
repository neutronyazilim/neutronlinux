#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/qtdeclarative" ] && { echo "qtdeclarative zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/qtshadertools" ] || { echo "once scripts/58c-qtshadertools.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$QTDECLARATIVE_SRC" ] || tar -xf "$SOURCES/$QTDECLARATIVE_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$QTDECLARATIVE_SRC"

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

touch "$STAMPS/qtdeclarative"
echo "qtdeclarative hazir"
