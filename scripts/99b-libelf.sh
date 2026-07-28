#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libelf" ] && { echo "libelf zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/zlib" ] || { echo "once zlib derlenmeli" >&2; exit 1; }

[ -d "$BUILD/$ELFUTILS_SRC" ] || tar -xf "$SOURCES/$ELFUTILS_SRC.tar.bz2" -C "$BUILD"
cd "$BUILD/$ELFUTILS_SRC"

[ -f Makefile ] || ./configure --host="$TARGET" --prefix=/usr \
    --disable-debuginfod --disable-libdebuginfod \
    --without-bzlib --without-lzma --without-zstd --with-zlib --disable-nls
make -C lib
make -C libelf

install -Dm755 libelf/libelf.so "$LFS/usr/lib/libelf.so"
ln -sf libelf.so "$LFS/usr/lib/libelf.so.1"
install -Dm644 libelf/libelf.h "$LFS/usr/include/libelf.h"
install -Dm644 libelf/gelf.h "$LFS/usr/include/gelf.h"
install -Dm644 config/libelf.pc "$LFS/usr/lib/pkgconfig/libelf.pc"

touch "$STAMPS/libelf"
echo "libelf hazir"
