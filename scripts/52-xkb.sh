#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libX11" ] || { echo "once scripts/50-libx11-libxext.sh calistirin" >&2; exit 1; }

build_autotools() {
    local name="$1" src="$2" extra_configure="$3"
    [ -f "$STAMPS/$name" ] && { echo "$name zaten derlenmis, atlaniyor"; return; }
    [ -d "$BUILD/$src" ] || tar -xf "$SOURCES/$src.tar.xz" -C "$BUILD"
    cd "$BUILD/$src"
    chmod +x config.guess build-aux/config.guess 2>/dev/null || true
    BUILD_TRIPLET="$([ -x ./config.guess ] && ./config.guess || build-aux/config.guess)"
    ./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc" $extra_configure
    make
    make DESTDIR="$LFS" install
    find "$LFS" -name '*.la' -delete
    touch "$STAMPS/$name"
    cd "$ROOT"
    echo "$name hazir"
}

build_autotools libxkbfile "$LIBXKBFILE_SRC" ""

if [ -f "$STAMPS/xkeyboard-config" ]; then
    echo "xkeyboard-config zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$XKEYBOARDCONFIG_SRC" ] || tar -xf "$SOURCES/$XKEYBOARDCONFIG_SRC.tar.xz" -C "$BUILD"
    cd "$BUILD/$XKEYBOARDCONFIG_SRC"
    rm -rf build
    meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dbuildtype=release \
        -Dxorg-rules-symlinks=true
    ninja -C build
    DESTDIR="$LFS" ninja -C build install
    touch "$STAMPS/xkeyboard-config"
    cd "$ROOT"
    echo "xkeyboard-config hazir"
fi

build_autotools xkbcomp "$XKBCOMP_SRC" ""
