#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libgudev" ] && { echo "libgudev zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/glib" ] || { echo "once glib icin ilgili scripti calistirin" >&2; exit 1; }
[ -f "$STAMPS/systemd" ] || { echo "once systemd icin ilgili scripti calistirin" >&2; exit 1; }

[ -d "$BUILD/$LIBGUDEV_SRC" ] || tar -xf "$SOURCES/$LIBGUDEV_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBGUDEV_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dtests=disabled -Dintrospection=disabled -Dvapi=disabled -Dgtk_doc=false
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/libgudev"
echo "libgudev hazir"
