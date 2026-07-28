#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libdisplay-info" ] && { echo "libdisplay-info zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LIBDISPLAYINFO_SRC" ] || tar -xf "$SOURCES/$LIBDISPLAYINFO_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$LIBDISPLAYINFO_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/libdisplay-info"
echo "libdisplay-info hazir"
