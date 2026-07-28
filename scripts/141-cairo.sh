#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/cairo" ] && { echo "cairo zaten derlenmis, atlaniyor"; exit 0; }
for dep in pixman freetype fontconfig libxcb libX11 glib zlib libpng; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$CAIRO_SRC" ] || tar -xf "$SOURCES/$CAIRO_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$CAIRO_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dfontconfig=enabled -Dfreetype=enabled -Dxcb=enabled -Dxlib=enabled \
    -Dpng=enabled -Dzlib=enabled -Dglib=enabled -Dtests=disabled
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/cairo"
echo "cairo hazir"
