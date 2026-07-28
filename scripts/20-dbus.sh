#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/dbus" ] && { echo "dbus zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/expat" ] || { echo "once scripts/19-expat.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$DBUS_SRC" ] || tar -xf "$SOURCES/$DBUS_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$DBUS_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr --sysconfdir=/etc \
    --localstatedir=/var \
    CC="$TARGET-gcc" \
    --disable-static --disable-tests --disable-embedded-tests \
    --disable-doxygen-docs --disable-xml-docs \
    --disable-selinux --disable-apparmor --disable-libaudit --disable-systemd \
    --with-session-socket-dir=/tmp

make
make DESTDIR="$LFS" install

touch "$STAMPS/dbus"
echo "dbus hazir"
