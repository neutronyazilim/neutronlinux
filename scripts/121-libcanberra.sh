#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libcanberra" ] && { echo "libcanberra zaten derlenmis, atlaniyor"; exit 0; }
for dep in libvorbis libtool alsa-lib; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$LIBCANBERRA_SRC" ] || tar -xf "$SOURCES/$LIBCANBERRA_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$LIBCANBERRA_SRC"

[ -f configure ] || ACLOCAL="aclocal -I $BUILD/m4-stubs" NOCONFIGURE=1 ./autogen.sh
BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --disable-static --disable-pulse --disable-gstreamer --disable-gtk \
    --disable-gtk-doc --disable-tdb --disable-oss \
    CC="$TARGET-gcc"
touch doc/README
make -j"$JOBS"
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/libcanberra"
echo "libcanberra hazir"
