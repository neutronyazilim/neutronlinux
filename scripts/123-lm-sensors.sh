#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/lm-sensors" ] && { echo "lm-sensors zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LMSENSORS_SRC" ] || tar -xf "$SOURCES/$LMSENSORS_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$LMSENSORS_SRC"

make -j"$JOBS" CC="$TARGET-gcc" AR="$TARGET-ar" PREFIX=/usr BUILD_STATIC_LIB=0
make DESTDIR="$LFS" PREFIX=/usr install \
    CC="$TARGET-gcc" AR="$TARGET-ar" BUILD_STATIC_LIB=0

touch "$STAMPS/lm-sensors"
echo "lm-sensors hazir"
