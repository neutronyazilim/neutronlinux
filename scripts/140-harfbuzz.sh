#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/harfbuzz" ] && { echo "harfbuzz zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/freetype" ] || { echo "once freetype icin ilgili scripti calistirin" >&2; exit 1; }

[ -d "$BUILD/$HARFBUZZ_SRC" ] || tar -xf "$SOURCES/$HARFBUZZ_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$HARFBUZZ_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dtests=disabled -Ddocs=disabled -Dbenchmark=disabled \
    -Dfreetype=enabled -Dglib=disabled -Dgobject=disabled -Dicu=disabled -Dcairo=disabled
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/harfbuzz"
echo "harfbuzz hazir"
