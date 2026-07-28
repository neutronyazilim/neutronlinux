#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/pixman" ] && { echo "pixman zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$PIXMAN_SRC" ] || tar -xf "$SOURCES/$PIXMAN_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$PIXMAN_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dbuildtype=release \
    -Dmmx=disabled -Dsse2=disabled -Dssse3=disabled -Dvmx=disabled \
    -Dgtk=disabled -Dlibpng=disabled -Dtests=disabled
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/pixman"
echo "pixman hazir"
