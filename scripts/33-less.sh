#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/less" ] && { echo "less zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/ncurses" ] || { echo "once scripts/15-ncurses.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$LESS_SRC" ] || tar -xf "$SOURCES/$LESS_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$LESS_SRC"

./configure --prefix=/usr CC="$TARGET-gcc"

make
make DESTDIR="$LFS" install

touch "$STAMPS/less"
echo "less hazir"
