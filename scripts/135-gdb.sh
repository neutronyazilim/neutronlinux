#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/gdb" ] && { echo "gdb zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$GDB_SRC" ] || tar -xf "$SOURCES/$GDB_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$GDB_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
rm -rf build && mkdir build && cd build
../configure --host="$TARGET" --build="$BUILD_TRIPLET" --target="$TARGET" \
    --prefix=/usr CC="$TARGET-gcc" CXX="$TARGET-g++" \
    --with-expat --with-system-zlib --enable-tui \
    --without-python --without-guile --disable-source-highlight \
    --without-debuginfod
make -j"$JOBS" all-gdb
make DESTDIR="$LFS" install-gdb

touch "$STAMPS/gdb"
echo "gdb hazir"
