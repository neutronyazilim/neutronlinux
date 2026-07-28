#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/layer-shell-qt" ] && { echo "layer-shell-qt zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/qtwayland" ] || { echo "once scripts/73-qtwayland.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$LAYERSHELLQT_SRC" ] || tar -xf "$SOURCES/$LAYERSHELLQT_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LAYERSHELLQT_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/layer-shell-qt"
echo "layer-shell-qt hazir"
