#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/gdk-pixbuf" ] && { echo "gdk-pixbuf zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/glib" ] || { echo "once glib icin ilgili scripti calistirin" >&2; exit 1; }
[ -f "$STAMPS/libpng" ] || { echo "once libpng icin ilgili scripti calistirin" >&2; exit 1; }

[ -d "$BUILD/$GDKPIXBUF_SRC" ] || tar -xf "$SOURCES/$GDKPIXBUF_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$GDKPIXBUF_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dpng=enabled -Dtiff=disabled -Djpeg=disabled -Dgif=enabled -Dglycin=disabled \
    -Dothers=enabled -Dbuiltin_loaders=all -Dintrospection=disabled \
    -Dman=false -Ddocumentation=false -Dtests=false -Dinstalled_tests=false \
    -Dgio_sniffing=false -Drelocatable=true
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/gdk-pixbuf"
echo "gdk-pixbuf hazir"
