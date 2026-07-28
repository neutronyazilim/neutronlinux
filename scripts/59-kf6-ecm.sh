#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/ecm" ] && { echo "ecm zaten kurulu, atlaniyor"; exit 0; }

[ -d "$BUILD/$ECM_SRC" ] || tar -xf "$SOURCES/$ECM_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$ECM_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
[ -f "$TOOLCHAIN_FILE" ] || { echo "once scripts/58-qtbase.sh calistirin (toolchain dosyasini yazar)" >&2; exit 1; }

rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_TESTING=OFF \
    -DBUILD_QTHELP_GENERATOR=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/ecm"
echo "ecm hazir"
