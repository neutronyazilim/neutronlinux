#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libxcb" ] || { echo "once scripts/49-libxcb.sh calistirin" >&2; exit 1; }

build_autotools() {
    local name="$1" src="$2" extra_configure="$3"
    [ -f "$STAMPS/$name" ] && { echo "$name zaten derlenmis, atlaniyor"; return; }
    [ -d "$BUILD/$src" ] || tar -xf "$SOURCES/$src.tar.xz" -C "$BUILD"
    cd "$BUILD/$src"
    chmod +x config.guess build-aux/config.guess 2>/dev/null || true
    BUILD_TRIPLET="$([ -x ./config.guess ] && ./config.guess || build-aux/config.guess)"
    ./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc" \
        --disable-malloc0returnsnull $extra_configure
    make
    make DESTDIR="$LFS" install
    find "$LFS" -name '*.la' -delete
    touch "$STAMPS/$name"
    cd "$ROOT"
    echo "$name hazir"
}

build_autotools libX11 "$LIBX11_SRC" "--disable-xlocaledir --without-xmlto --without-fop"
build_autotools libXext "$LIBXEXT_SRC" ""
build_autotools libXfixes "$LIBXFIXES_SRC" ""
