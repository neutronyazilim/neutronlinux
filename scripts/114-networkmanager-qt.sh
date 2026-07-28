#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/networkmanager-qt" ] && { echo "networkmanager-qt zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$NETWORKMANAGERQT_SRC" ] || tar -xf "$SOURCES/$NETWORKMANAGERQT_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$NETWORKMANAGERQT_SRC"

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

touch "$STAMPS/networkmanager-qt"
echo "networkmanager-qt hazir"
