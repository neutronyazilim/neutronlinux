#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libXcursor" ] && { echo "libXcursor zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/libXrender" ] || { echo "once libXrender icin ilgili scripti calistirin" >&2; exit 1; }
[ -f "$STAMPS/libXfixes" ] || { echo "once libXfixes icin ilgili scripti calistirin" >&2; exit 1; }

[ -d "$BUILD/$LIBXCURSOR_SRC" ] || tar -xf "$SOURCES/$LIBXCURSOR_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBXCURSOR_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static CC="$TARGET-gcc"
make
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libXcursor"
echo "libXcursor hazir"
