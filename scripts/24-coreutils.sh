#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/coreutils" ] && { echo "coreutils zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$COREUTILS_SRC" ] || tar -xf "$SOURCES/$COREUTILS_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$COREUTILS_SRC"

BUILD_TRIPLET="$(build-aux/config.guess)"
FORCE_UNSAFE_CONFIGURE=1 ./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" \
    --disable-nls

make
make DESTDIR="$LFS" install

touch "$STAMPS/coreutils"
echo "coreutils hazir"
file "$LFS/usr/bin/ls"
