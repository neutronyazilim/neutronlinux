#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/util-macros" ] && { echo "util-macros zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$UTILMACROS_SRC" ] || tar -xf "$SOURCES/$UTILMACROS_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$UTILMACROS_SRC"

./configure --prefix=/usr
make DESTDIR="$LFS" install

touch "$STAMPS/util-macros"
echo "util-macros hazir"
