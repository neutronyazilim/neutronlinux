#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/qcoro" ] && { echo "qcoro zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/qtdeclarative" ] || { echo "once scripts/58d-qtdeclarative.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$QCORO_SRC" ] || tar -xf "$SOURCES/$QCORO_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$QCORO_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DQCORO_BUILD_EXAMPLES=OFF \
    -DQCORO_BUILD_TESTING=OFF \
    -DQCORO_WITH_QTWEBSOCKETS=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/qcoro"
echo "qcoro hazir"
