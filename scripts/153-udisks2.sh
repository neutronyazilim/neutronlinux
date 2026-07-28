#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/udisks2" ] && { echo "udisks2 zaten derlenmis, atlaniyor"; exit 0; }
for dep in glib libgudev polkit acl-attr; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$UDISKS2_SRC" ] || tar -xf "$SOURCES/$UDISKS2_SRC.tar.bz2" -C "$BUILD"
cd "$BUILD/$UDISKS2_SRC"

BUILD_TRIPLET="$(sh ./build-aux/config.guess 2>/dev/null || sh ./config.guess 2>/dev/null)"
./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    --sysconfdir=/etc --localstatedir=/var \
    CC="$TARGET-gcc" PKG_CONFIG_SYSROOT_DIR="$LFS" PKG_CONFIG_PATH="$LFS/usr/lib/pkgconfig" \
    --disable-man --disable-gtk-doc --disable-fhs-media \
    --enable-daemon

make
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/udisks2"
echo "udisks2 hazir"
