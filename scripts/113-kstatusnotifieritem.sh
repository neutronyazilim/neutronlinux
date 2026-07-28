#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kstatusnotifieritem" ] && { echo "kstatusnotifieritem zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/kwindowsystem" ] || { echo "once kwindowsystem icin ilgili scripti calistirin" >&2; exit 1; }

[ -d "$BUILD/$KSTATUSNOTIFIERITEM_SRC" ] || tar -xf "$SOURCES/$KSTATUSNOTIFIERITEM_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$KSTATUSNOTIFIERITEM_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF \
    -DBUILD_PYTHON_BINDINGS=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/kstatusnotifieritem"
echo "kstatusnotifieritem hazir"
