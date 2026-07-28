#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libvorbis" ] && { echo "libvorbis zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/libogg" ] || { echo "once scripts/117-libogg.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$LIBVORBIS_SRC" ] || tar -xf "$SOURCES/$LIBVORBIS_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBVORBIS_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static CC="$TARGET-gcc"
make -j"$JOBS"
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libvorbis"
echo "libvorbis hazir"
