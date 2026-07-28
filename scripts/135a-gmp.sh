#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/gmp" ] && { echo "gmp zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$GMP_SRC" ] || tar -xf "$SOURCES/$GMP_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$GMP_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" CXX="$TARGET-g++" CXXCPP="$TARGET-g++ -E" \
    --disable-static --enable-shared --disable-cxx
make -j"$JOBS"
make DESTDIR="$LFS" install

touch "$STAMPS/gmp"
echo "gmp hazir"
