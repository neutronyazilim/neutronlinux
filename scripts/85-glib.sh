#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/glib" ] && { echo "glib zaten derlenmis, atlaniyor"; exit 0; }
for dep in pcre2 libffi zlib util-linux; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$GLIB_SRC" ] || tar -xf "$SOURCES/$GLIB_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$GLIB_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dselinux=disabled -Dxattr=true -Dlibmount=enabled \
    -Dman=false -Dman-pages=disabled -Ddtrace=disabled -Dsystemtap=disabled \
    -Dsysprof=disabled -Ddocumentation=false -Dgtk_doc=false \
    -Dtests=false -Dinstalled_tests=false -Dintrospection=disabled \
    -Dnls=enabled
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/glib"
echo "glib hazir"
