#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/fontconfig" ] || { echo "once scripts/55-dwm-st-xinit.sh calistirin" >&2; exit 1; }

build_autotools() {
    local name="$1" src="$2" extra="$3"
    [ -f "$STAMPS/$name" ] && { echo "$name zaten derlenmis, atlaniyor"; return; }
    [ -d "$BUILD/$src" ] || tar -xf "$SOURCES/$src.tar.xz" -C "$BUILD"
    cd "$BUILD/$src"
    CG="$(find . -maxdepth 2 -name config.guess | head -1)"
    chmod +x "$CG"
    BUILD_TRIPLET="$("$CG")"
    ./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc" $extra
    make
    make DESTDIR="$LFS" install
    find "$LFS" -name '*.la' -delete
    touch "$STAMPS/$name"
    cd "$ROOT"
    echo "$name hazir"
}

build_autotools libICE "$LIBICE_SRC" ""
build_autotools libSM "$LIBSM_SRC" ""
build_autotools libXt "$LIBXT_SRC" ""
build_autotools libXmu "$LIBXMU_SRC" ""
build_autotools xauth "$XAUTH_SRC" ""

if [ -f "$STAMPS/dejavu-fonts" ]; then
    echo "dejavu-fonts zaten kurulu, atlaniyor"
else
    [ -d "$BUILD/$DEJAVU_SRC" ] || tar -xf "$SOURCES/$DEJAVU_SRC.tar.bz2" -C "$BUILD"
    mkdir -p "$LFS/usr/share/fonts/truetype/dejavu"
    cp "$BUILD/$DEJAVU_SRC"/ttf/*.ttf "$LFS/usr/share/fonts/truetype/dejavu/"
    touch "$STAMPS/dejavu-fonts"
    echo "dejavu-fonts hazir"
fi
