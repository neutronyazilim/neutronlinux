#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/at-spi2-core" ] && { echo "at-spi2-core zaten derlenmis, atlaniyor"; exit 0; }
for dep in dbus glib libxml2 libX11 libXtst libXi; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$ATSPI2CORE_SRC" ] || tar -xf "$SOURCES/$ATSPI2CORE_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$ATSPI2CORE_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dx11=enabled -Dintrospection=disabled -Ddocs=false -Datk_only=false \
    -Duse_systemd=true -Ddefault_bus=dbus-daemon
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/at-spi2-core"
echo "at-spi2-core hazir"
