#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/xorgproto" ] || { echo "once scripts/43-xorgproto.sh calistirin" >&2; exit 1; }

if [ -f "$STAMPS/zlib" ]; then
    echo "zlib zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$ZLIB_SRC" ] || tar -xf "$SOURCES/$ZLIB_SRC.tar.gz" -C "$BUILD"
    cd "$BUILD/$ZLIB_SRC"
    CC="$TARGET-gcc" CHOST="$TARGET" AR="$TARGET-ar" RANLIB="$TARGET-ranlib" \
        ./configure --prefix=/usr
    make
    make DESTDIR="$LFS" install
    touch "$STAMPS/zlib"
    cd "$ROOT"
    echo "zlib hazir"
fi

if [ -f "$STAMPS/freetype" ]; then
    echo "freetype zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$FREETYPE_SRC" ] || tar -xf "$SOURCES/$FREETYPE_SRC.tar.xz" -C "$BUILD"
    cd "$BUILD/$FREETYPE_SRC"
    chmod +x builds/unix/config.guess build-aux/config.guess 2>/dev/null || true
    BUILD_TRIPLET="$(builds/unix/config.guess 2>/dev/null || build-aux/config.guess)"
    ./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc" \
        --without-harfbuzz --without-png --without-bzip2 --without-brotli
    make
    make DESTDIR="$LFS" install
    find "$LFS" -name '*.la' -delete
    touch "$STAMPS/freetype"
    cd "$ROOT"
    echo "freetype hazir"
fi

build_autotools() {
    local name="$1" src="$2"
    [ -f "$STAMPS/$name" ] && { echo "$name zaten derlenmis, atlaniyor"; return; }
    [ -d "$BUILD/$src" ] || tar -xf "$SOURCES/$src.tar.xz" -C "$BUILD"
    cd "$BUILD/$src"
    chmod +x config.guess build-aux/config.guess 2>/dev/null || true
    BUILD_TRIPLET="$([ -x ./config.guess ] && ./config.guess || build-aux/config.guess)"
    ./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"
    make
    make DESTDIR="$LFS" install
    find "$LFS" -name '*.la' -delete
    touch "$STAMPS/$name"
    cd "$ROOT"
    echo "$name hazir"
}

build_autotools libmd "$LIBMD_SRC"
build_autotools libfontenc "$LIBFONTENC_SRC"
build_autotools libXfont2 "$LIBXFONT2_SRC"
build_autotools font-util "$FONTUTIL_SRC"

if [ -f "$STAMPS/libxcvt" ]; then
    echo "libxcvt zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$LIBXCVT_SRC" ] || tar -xf "$SOURCES/$LIBXCVT_SRC.tar.xz" -C "$BUILD"
    cd "$BUILD/$LIBXCVT_SRC"
    rm -rf build
    meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dbuildtype=release
    ninja -C build
    DESTDIR="$LFS" ninja -C build install
    touch "$STAMPS/libxcvt"
    cd "$ROOT"
    echo "libxcvt hazir"
fi
