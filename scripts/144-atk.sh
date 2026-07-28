#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/atk" ] && { echo "atk zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/glib" ] || { echo "once glib icin ilgili scripti calistirin" >&2; exit 1; }

[ -d "$BUILD/$ATK_SRC" ] || tar -xf "$SOURCES/$ATK_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$ATK_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dintrospection=false
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/atk"
echo "atk hazir"
