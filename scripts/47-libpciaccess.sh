#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libpciaccess" ] && { echo "libpciaccess zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LIBPCIACCESS_SRC" ] || tar -xf "$SOURCES/$LIBPCIACCESS_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBPCIACCESS_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dbuildtype=release -Dzlib=disabled
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/libpciaccess"
echo "libpciaccess hazir"
