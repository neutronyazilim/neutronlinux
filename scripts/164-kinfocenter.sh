#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kinfocenter" ] && { echo "kinfocenter zaten derlenmis, atlaniyor"; exit 0; }
for dep in systemsettings libdrm systemd vulkan-headers; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$KINFOCENTER_SRC" ] || tar -xf "$SOURCES/$KINFOCENTER_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$KINFOCENTER_SRC"

sed -i \
    -e '/^add_subdirectory(opengl-helper)/d' \
    -e '/^add_subdirectory(vulkan-helper)/d' \
    kcms/about-distro/src/CMakeLists.txt

sed -i 's|#include <QVulkanInstance>|#include <vulkan/vulkan_core.h>|' \
    kcms/about-distro/src/GPUEntry.h

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF \
    -DBUILD_DOC=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/kinfocenter"
echo "kinfocenter hazir"
