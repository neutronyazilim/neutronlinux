#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kwayland" ] && { echo "kwayland zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/qtwayland" ] || { echo "once scripts/73-qtwayland.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$KWAYLAND_SRC" ] || tar -xf "$SOURCES/$KWAYLAND_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$KWAYLAND_SRC"

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

touch "$STAMPS/kwayland"
echo "kwayland hazir"
