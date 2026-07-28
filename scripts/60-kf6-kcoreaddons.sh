#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kcoreaddons" ] && { echo "kcoreaddons zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/ecm" ] || { echo "once scripts/59-kf6-ecm.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/qtbase" ] || { echo "once scripts/58-qtbase.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$KCOREADDONS_SRC" ] || tar -xf "$SOURCES/$KCOREADDONS_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$KCOREADDONS_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF \
    -DBUILD_QCH=OFF \
    -DKCOREADDONS_USE_QML=ON \
    -DBUILD_PYTHON_BINDINGS=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/kcoreaddons"
echo "kcoreaddons hazir"
