#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/fribidi" ] && { echo "fribidi zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$FRIBIDI_SRC" ] || tar -xf "$SOURCES/$FRIBIDI_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$FRIBIDI_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dtests=false -Ddocs=false -Dbin=false
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/fribidi"
echo "fribidi hazir"
