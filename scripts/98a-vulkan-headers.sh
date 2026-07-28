#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/vulkan-headers" ] && { echo "vulkan-headers zaten kurulu, atlaniyor"; exit 0; }

[ -d "$BUILD/$VULKANHEADERS_SRC" ] || tar -xf "$SOURCES/$VULKANHEADERS_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$VULKANHEADERS_SRC"

cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/usr
DESTDIR="$LFS" cmake --install build

touch "$STAMPS/vulkan-headers"
echo "vulkan-headers hazir"
