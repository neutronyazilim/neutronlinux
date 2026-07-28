#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libepoxy" ] && { echo "libepoxy zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/libglvnd" ] || { echo "once scripts/96-libglvnd.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/libX11" ] || { echo "once libX11 icin ilgili scripti calistirin" >&2; exit 1; }

[ -d "$BUILD/$LIBEPOXY_SRC" ] || tar -xf "$SOURCES/$LIBEPOXY_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$LIBEPOXY_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dglx=yes -Degl=yes -Dx11=true -Dtests=false
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/libepoxy"
echo "libepoxy hazir"
