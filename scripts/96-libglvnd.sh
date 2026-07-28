#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libglvnd" ] && { echo "libglvnd zaten derlenmis, atlaniyor"; exit 0; }
for dep in libX11 libXext; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$LIBGLVND_SRC" ] || tar -xf "$SOURCES/$LIBGLVND_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$LIBGLVND_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dx11=enabled -Dglx=enabled -Degl=true -Dgles1=true -Dgles2=true -Dhgl=false -Dheaders=true
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/libglvnd"
echo "libglvnd hazir"
