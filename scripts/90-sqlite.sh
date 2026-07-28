#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/sqlite" ] && { echo "sqlite zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$SQLITE_SRC" ] || tar -xf "$SOURCES/$SQLITE_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$SQLITE_SRC"

./configure --host="$TARGET" --prefix=/usr \
    --disable-static CC="$TARGET-gcc"
make
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/sqlite"
echo "sqlite hazir"
