#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/xorgproto" ] || { echo "once scripts/43-xorgproto.sh calistirin" >&2; exit 1; }

build_autotools() {
    local name="$1" src="$2" tarext="$3"
    [ -f "$STAMPS/$name" ] && { echo "$name zaten derlenmis, atlaniyor"; return; }
    [ -d "$BUILD/$src" ] || tar -xf "$SOURCES/$src.$tarext" -C "$BUILD"
    cd "$BUILD/$src"
    chmod +x config.guess 2>/dev/null || chmod +x build-aux/config.guess 2>/dev/null || true
    BUILD_TRIPLET="$([ -x ./config.guess ] && ./config.guess || build-aux/config.guess)"
    ./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"
    make
    make DESTDIR="$LFS" install
    find "$LFS" -name '*.la' -delete
    touch "$STAMPS/$name"
    cd "$ROOT"
    echo "$name hazir"
}

build_autotools libXau "$LIBXAU_SRC" tar.xz
build_autotools libXdmcp "$LIBXDMCP_SRC" tar.xz
