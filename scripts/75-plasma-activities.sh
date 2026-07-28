#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/plasma-activities" ] && { echo "plasma-activities zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/kcoreaddons" ] || { echo "once scripts/60-kf6-kcoreaddons.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$PLASMAACTIVITIES_SRC" ] || tar -xf "$SOURCES/$PLASMAACTIVITIES_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$PLASMAACTIVITIES_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF \
    -DPLASMA_ACTIVITIES_LIBRARY_ONLY=ON
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/plasma-activities"
echo "plasma-activities hazir"
