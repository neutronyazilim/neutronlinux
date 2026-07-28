#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/wayland" ] && { echo "wayland zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/libffi" ] || { echo "once scripts/70-libffi.sh calistirin" >&2; exit 1; }
command -v wayland-scanner >/dev/null || { echo "host'ta wayland-scanner yok: sudo pacman -S wayland" >&2; exit 1; }

[ -d "$BUILD/$WAYLAND_SRC" ] || tar -xf "$SOURCES/$WAYLAND_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$WAYLAND_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dlibraries=true -Dscanner=true -Dtests=false -Ddocumentation=false \
    -Ddtd_validation=false
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/wayland"
echo "wayland hazir"
