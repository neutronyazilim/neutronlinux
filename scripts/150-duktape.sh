#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/duktape" ] && { echo "duktape zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$DUKTAPE_SRC" ] || tar -xf "$SOURCES/$DUKTAPE_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$DUKTAPE_SRC"

make -f Makefile.sharedlibrary clean 2>/dev/null || true
make -f Makefile.sharedlibrary CC="$TARGET-gcc" INSTALL_PREFIX=/usr LIBDIR=/lib
make -f Makefile.sharedlibrary install CC="$TARGET-gcc" INSTALL_PREFIX=/usr LIBDIR=/lib DESTDIR="$LFS"

touch "$STAMPS/duktape"
echo "duktape hazir"
