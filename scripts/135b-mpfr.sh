#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/mpfr" ] && { echo "mpfr zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/gmp" ] || { echo "once scripts/135a-gmp.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$MPFR_SRC" ] || tar -xf "$SOURCES/$MPFR_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$MPFR_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" --disable-static --enable-shared
make -j"$JOBS"
make DESTDIR="$LFS" install

touch "$STAMPS/mpfr"
echo "mpfr hazir"
