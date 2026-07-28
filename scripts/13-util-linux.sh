#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/util-linux" ] && { echo "util-linux zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/ncurses" ] || { echo "once scripts/15-ncurses.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$UTIL_LINUX_SRC" ] || tar -xf "$SOURCES/$UTIL_LINUX_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$UTIL_LINUX_SRC"

[ -f pam_lastlog2/meson.build ] || echo '# stub: not shipped in release tarball' > pam_lastlog2/meson.build

rm -rf build
meson setup build \
    --cross-file="$MESON_CROSS" --prefix=/usr --libdir=/usr/lib \
    -Dbuildtype=release \
    -Dbuild-python=disabled \
    -Dbuild-liblastlog2=disabled \
    -Dbuild-pam-lastlog2=disabled \
    -Dbuild-cramfs=disabled \
    -Dprogram-tests=false

ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/util-linux"
echo "util-linux hazir"
