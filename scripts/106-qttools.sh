#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/qttools" ] && { echo "qttools zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/qtbase" ] || { echo "once scripts/58-qtbase.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$QTTOOLS_SRC" ] || tar -xf "$SOURCES/$QTTOOLS_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$QTTOOLS_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DQT_BUILD_EXAMPLES=OFF \
    -DQT_BUILD_TESTS=OFF \
    -DFEATURE_linguist=OFF \
    -DFEATURE_designer=OFF \
    -DFEATURE_assistant=OFF \
    -DFEATURE_pixeltool=OFF \
    -DFEATURE_distancefieldgenerator=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/qttools"
echo "qttools hazir"
