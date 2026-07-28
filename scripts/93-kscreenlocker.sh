#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kscreenlocker" ] && { echo "kscreenlocker zaten derlenmis, atlaniyor"; exit 0; }
for dep in layer-shell-qt kscreen libkscreen libplasma pam; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$KSCREENLOCKER_SRC" ] || tar -xf "$SOURCES/$KSCREENLOCKER_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$KSCREENLOCKER_SRC"

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

touch "$STAMPS/kscreenlocker"
echo "kscreenlocker hazir"
