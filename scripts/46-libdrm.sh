#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libdrm" ] && { echo "libdrm zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LIBDRM_SRC" ] || tar -xf "$SOURCES/$LIBDRM_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBDRM_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dbuildtype=release \
    -Dintel=enabled -Dradeon=enabled -Damdgpu=enabled -Dnouveau=enabled \
    -Dvmwgfx=disabled -Dvc4=disabled -Dfreedreno=disabled -Detnaviv=disabled \
    -Dtegra=disabled -Dcairo-tests=disabled -Dvalgrind=disabled -Dman-pages=disabled \
    -Dudev=true
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/libdrm"
echo "libdrm hazir"
