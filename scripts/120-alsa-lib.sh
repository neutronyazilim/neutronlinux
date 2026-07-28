#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/alsa-lib" ] && { echo "alsa-lib zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$ALSALIB_SRC" ] || tar -xf "$SOURCES/$ALSALIB_SRC.tar.bz2" -C "$BUILD"
cd "$BUILD/$ALSALIB_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static --disable-python CC="$TARGET-gcc"
make -j"$JOBS"
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/alsa-lib"
echo "alsa-lib hazir"
