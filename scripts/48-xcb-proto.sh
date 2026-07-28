#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/xcb-proto" ] && { echo "xcb-proto zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$XCBPROTO_SRC" ] || tar -xf "$SOURCES/$XCBPROTO_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$XCBPROTO_SRC"

./configure --prefix=/usr
make
make DESTDIR="$LFS" install

touch "$STAMPS/xcb-proto"
echo "xcb-proto hazir"
