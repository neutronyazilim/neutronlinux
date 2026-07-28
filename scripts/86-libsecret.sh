#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libsecret" ] && { echo "libsecret zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/glib" ] || { echo "once scripts/85-glib.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/libgcrypt" ] || { echo "once scripts/81-libgcrypt.sh calistirin" >&2; exit 1; }

[ -d "$BUILD/$LIBSECRET_SRC" ] || tar -xf "$SOURCES/$LIBSECRET_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LIBSECRET_SRC"

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dcrypto=libgcrypt -Dmanpage=false -Dvapi=false -Dgtk_doc=false \
    -Dintrospection=false -Dbash_completion=disabled
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/libsecret"
echo "libsecret hazir"
