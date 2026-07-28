#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"

if [ -f "$STAMPS/xorgproto" ]; then
    echo "xorgproto zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$XORGPROTO_SRC" ] || tar -xf "$SOURCES/$XORGPROTO_SRC.tar.xz" -C "$BUILD"
    cd "$BUILD/$XORGPROTO_SRC"
    rm -rf build
    meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dlegacy=true
    ninja -C build
    DESTDIR="$LFS" ninja -C build install
    touch "$STAMPS/xorgproto"
    cd "$ROOT"
    echo "xorgproto hazir"
fi

if [ -f "$STAMPS/xtrans" ]; then
    echo "xtrans zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$XTRANS_SRC" ] || tar -xf "$SOURCES/$XTRANS_SRC.tar.xz" -C "$BUILD"
    cd "$BUILD/$XTRANS_SRC"
    chmod +x config.guess build-aux/config.guess 2>/dev/null || true
    BUILD_TRIPLET="$([ -x ./config.guess ] && ./config.guess || build-aux/config.guess)"
    ./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr
    make
    make DESTDIR="$LFS" install
    touch "$STAMPS/xtrans"
    cd "$ROOT"
    echo "xtrans hazir"
fi
