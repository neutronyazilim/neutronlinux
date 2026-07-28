#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/ncurses" ] && { echo "ncurses zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$NCURSES_SRC" ] || tar -xf "$SOURCES/$NCURSES_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$NCURSES_SRC"

BUILD_TRIPLET="$(sh ./config.guess)"
./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" CXX="$TARGET-g++" \
    --with-build-cc=gcc-15 --with-build-cpp=gcc-15\ -E \
    --without-ada --without-manpages --without-tests --without-debug \
    --enable-widec --with-shared --without-static --with-cxx-shared \
    --enable-pc-files --with-pkg-config-libdir=/usr/lib/pkgconfig

make
make DESTDIR="$LFS" install

touch "$STAMPS/ncurses"
echo "ncurses hazir"
