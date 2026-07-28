#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libXrandr" ] && { echo "libXrandr zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/libXrender" ] || { echo "once libXrender icin ilgili scripti calistirin" >&2; exit 1; }
[ -f "$STAMPS/libXext" ] || { echo "once scripts/50-libx11-libxext.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$LIBXRANDR_SRC" ] || tar -xf "$SOURCES/$LIBXRANDR_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBXRANDR_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static --enable-malloc0returnsnull=no CC="$TARGET-gcc"
make
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libXrandr"
echo "libXrandr hazir"
