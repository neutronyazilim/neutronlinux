#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/gtk3" ] && { echo "gtk3 zaten derlenmis, atlaniyor"; exit 0; }
for dep in cairo pango atk gdk-pixbuf glib libxcb libX11 libXi libXext libXrandr \
           libXcursor libXcomposite libXdamage libXfixes; do
    [ -f "$STAMPS/$dep" ] || echo "uyari: $dep stamp'i yok, olmayabilir/farkli adda olabilir" >&2
done
for dep in cairo pango atk gdk-pixbuf glib libxcb libX11; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$GTK3_SRC" ] || tar -xf "$SOURCES/$GTK3_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$GTK3_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dx11_backend=true -Dwayland_backend=false -Dbroadway_backend=false \
    -Dintrospection=false -Ddemos=false -Dexamples=false -Dtests=false \
    -Dgtk_doc=false -Dman=false -Dcolord=no -Dprint_backends=file \
    -Dxinerama=auto -Dcloudproviders=false -Dtracker3=false
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/gtk3"
echo "gtk3 hazir"
