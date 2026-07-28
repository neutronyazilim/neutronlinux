#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/qrencode" ] && { echo "qrencode zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$QRENCODE_SRC" ] || tar -xf "$SOURCES/qrencode-$QRENCODE_VER.tar.gz" -C "$BUILD"
cd "$BUILD/$QRENCODE_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DBUILD_SHARED_LIBS=ON \
    -DWITHOUT_PNG=YES \
    -DWITH_TOOLS=NO \
    -DWITH_TESTS=NO
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/qrencode"
echo "qrencode hazir"
