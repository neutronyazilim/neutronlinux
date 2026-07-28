#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"

build_protocols() {
    local name="$1" src="$2"
    [ -f "$STAMPS/$name" ] && { echo "$name zaten derlenmis, atlaniyor"; return; }
    [ -d "$BUILD/$src" ] || tar -xf "$SOURCES/$src.tar.xz" -C "$BUILD"
    cd "$BUILD/$src"
    rm -rf build
    meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release
    ninja -C build
    DESTDIR="$LFS" ninja -C build install
    touch "$STAMPS/$name"
    cd "$ROOT"
    echo "$name hazir"
}

build_protocols wayland-protocols "$WAYLANDPROTOCOLS_SRC"

[ -f "$STAMPS/plasma-wayland-protocols" ] || {
    [ -d "$BUILD/$PLASMAWAYLANDPROTOCOLS_SRC" ] || tar -xf "$SOURCES/$PLASMAWAYLANDPROTOCOLS_SRC.tar.xz" -C "$BUILD"
    cd "$BUILD/$PLASMAWAYLANDPROTOCOLS_SRC"
    rm -rf build
    TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
    cmake -S . -B build -G Ninja \
        -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr
    ninja -C build
    DESTDIR="$LFS" ninja -C build install
    touch "$STAMPS/plasma-wayland-protocols"
    cd "$ROOT"
    echo "plasma-wayland-protocols hazir"
}
