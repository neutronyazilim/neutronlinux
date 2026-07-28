#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/pango" ] && { echo "pango zaten derlenmis, atlaniyor"; exit 0; }
for dep in harfbuzz cairo fribidi glib fontconfig freetype; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$PANGO_SRC" ] || tar -xf "$SOURCES/$PANGO_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$PANGO_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dintrospection=disabled -Dbuild-testsuite=false -Dbuild-examples=false \
    -Dfontconfig=enabled -Dcairo=enabled -Dxft=enabled -Dfreetype=enabled -Dlibthai=disabled
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/pango"
echo "pango hazir"
