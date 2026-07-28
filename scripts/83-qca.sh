#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/qca" ] && { echo "qca zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/qt5compat" ] || { echo "once scripts/82-qt5compat.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/openssl" ] || { echo "once scripts/58e-openssl.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$QCA_SRC" ] || tar -xf "$SOURCES/$QCA_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$QCA_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT6=ON \
    -DBUILD_TESTS=OFF \
    -DBUILD_TOOLS=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

sed -i "s|INTERFACE_INCLUDE_DIRECTORIES \"/usr/include/Qca-qt6/QtCrypto\"|INTERFACE_INCLUDE_DIRECTORIES \"$LFS/usr/include/Qca-qt6/QtCrypto\"|" \
    "$LFS/usr/lib/cmake/Qca-qt6/Qca-qt6Targets.cmake"
sed -i "s|\"/usr/lib/libqca-qt6.so|\"$LFS/usr/lib/libqca-qt6.so|g" \
    "$LFS/usr/lib/cmake/Qca-qt6/Qca-qt6Targets-release.cmake"

touch "$STAMPS/qca"
echo "qca hazir"
