#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/icu" ] && { echo "icu zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/icu" ] || tar -xf "$SOURCES/$ICU_SRC.tgz" -C "$BUILD"

NEUTRON_TARGET="$TARGET"

if [ ! -f "$STAMPS/icu-native" ]; then
    mkdir -p "$BUILD/icu-native"
    ( cd "$BUILD/icu-native"
      unset TARGET
      "$BUILD/icu/source/runConfigureICU" Linux --disable-tests --disable-samples
      make -j"$JOBS" )
    touch "$STAMPS/icu-native"
    echo "icu-native hazir"
fi

mkdir -p "$BUILD/icu-cross"
( cd "$BUILD/icu-cross"
  CC="$NEUTRON_TARGET-gcc" CXX="$NEUTRON_TARGET-g++" \
      "$BUILD/icu/source/configure" \
      --host="$NEUTRON_TARGET" --prefix=/usr \
      --with-cross-build="$BUILD/icu-native" \
      --disable-tests --disable-samples --disable-static
  unset TARGET
  make -j"$JOBS"
  make DESTDIR="$LFS" install )

touch "$STAMPS/icu"
echo "icu hazir"
