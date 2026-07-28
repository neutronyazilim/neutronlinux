#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/nspr" ] && { echo "nspr zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$NSPR_SRC" ] || tar -xf "$SOURCES/$NSPR_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$NSPR_SRC/nspr"

cp /usr/share/automake-*/config.guess /usr/share/automake-*/config.sub build/autoconf/ 2>/dev/null || \
    cp /usr/share/autoconf/build-aux/config.guess /usr/share/autoconf/build-aux/config.sub build/autoconf/

BUILD_TRIPLET="$(sh ./build/autoconf/config.guess)"
rm -rf objdir
mkdir objdir
cd objdir
CC="$TARGET-gcc" CXX="$TARGET-g++" AR="$TARGET-ar" RANLIB="$TARGET-ranlib" \
  ../configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --libdir=/usr/lib --enable-64bit --disable-debug --enable-optimize
make -j"$JOBS"
make DESTDIR="$LFS" install

touch "$STAMPS/nspr"
echo "nspr hazir"
