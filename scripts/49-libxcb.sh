#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libxcb" ] && { echo "libxcb zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/xcb-proto" ] || { echo "once scripts/48-xcb-proto.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$LIBXCB_SRC" ] || tar -xf "$SOURCES/$LIBXCB_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBXCB_SRC"

PY_SITE="$(python3 -c 'import sys; print(f"lib/python{sys.version_info.major}.{sys.version_info.minor}/site-packages")')"
export PYTHONPATH="$LFS/usr/$PY_SITE"

BUILD_TRIPLET="$(chmod +x build-aux/config.guess 2>/dev/null; build-aux/config.guess 2>/dev/null || (chmod +x config.guess && ./config.guess))"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" PYTHON=python3 \
    --disable-devel-docs --without-doxygen
make
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libxcb"
echo "libxcb hazir"
