#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kactivitymanagerd" ] && { echo "kactivitymanagerd zaten derlenmis, atlaniyor"; exit 0; }
for dep in boost plasma-activities; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$KACTIVITYMANAGERD_SRC" ] || tar -xf "$SOURCES/$KACTIVITYMANAGERD_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$KACTIVITYMANAGERD_SRC"

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

touch "$STAMPS/kactivitymanagerd"
echo "kactivitymanagerd hazir"
