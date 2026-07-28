#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/plasma5support" ] && { echo "plasma5support zaten derlenmis, atlaniyor"; exit 0; }
for dep in libksysguard plasma-activities; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$PLASMA5SUPPORT_SRC" ] || tar -xf "$SOURCES/$PLASMA5SUPPORT_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$PLASMA5SUPPORT_SRC"

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

touch "$STAMPS/plasma5support"
echo "plasma5support hazir"
