#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/diffutils" ] && { echo "diffutils zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$DIFFUTILS_SRC" ] || tar -xf "$SOURCES/$DIFFUTILS_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$DIFFUTILS_SRC"

BUILD_TRIPLET="$(build-aux/config.guess)"
gl_cv_func_strcasecmp_works=yes \
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"

make
make DESTDIR="$LFS" install

touch "$STAMPS/diffutils"
echo "diffutils hazir"
