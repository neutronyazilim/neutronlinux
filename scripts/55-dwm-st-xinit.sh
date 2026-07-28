#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/xorg-server" ] || { echo "once scripts/53-xorg-server.sh calistirin" >&2; exit 1; }

build_autotools() {
    local name="$1" src="$2" tarext="$3" extra="$4"
    [ -f "$STAMPS/$name" ] && { echo "$name zaten derlenmis, atlaniyor"; return; }
    [ -d "$BUILD/$src" ] || tar -xf "$SOURCES/$src.$tarext" -C "$BUILD"
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

build_autotools libXinerama "$LIBXINERAMA_SRC" tar.xz ""
build_autotools libXrender "$LIBXRENDER_SRC" tar.xz ""

if [ -f "$STAMPS/fontconfig" ]; then
    echo "fontconfig zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$FONTCONFIG_SRC" ] || tar -xf "$SOURCES/$FONTCONFIG_SRC.tar.xz" -C "$BUILD"
    cd "$BUILD/$FONTCONFIG_SRC"
    rm -rf build
    meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dbuildtype=release \
        -Dcache-build=disabled -Diconv=disabled -Dnls=disabled \
        -Dtests=disabled -Dtools=disabled -Ddoc=disabled
    ninja -C build
    DESTDIR="$LFS" ninja -C build install
    touch "$STAMPS/fontconfig"
    cd "$ROOT"
    echo "fontconfig hazir"
fi

build_autotools libXft "$LIBXFT_SRC" tar.xz ""

if [ -f "$STAMPS/dwm" ]; then
    echo "dwm zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$DWM_SRC" ] || tar -xf "$SOURCES/$DWM_SRC.tar.gz" -C "$BUILD"
    cd "$BUILD/$DWM_SRC"
    make CC="$TARGET-gcc" \
        X11INC="$LFS/usr/include" X11LIB="$LFS/usr/lib" \
        FREETYPEINC="$LFS/usr/include/freetype2" \
        DESTDIR="$LFS" PREFIX=/usr install
    touch "$STAMPS/dwm"
    cd "$ROOT"
    echo "dwm hazir"
fi

if [ -f "$STAMPS/st" ]; then
    echo "st zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$ST_SRC" ] || tar -xf "$SOURCES/$ST_SRC.tar.gz" -C "$BUILD"
    cd "$BUILD/$ST_SRC"
    make CC="$TARGET-gcc" \
        X11INC="$LFS/usr/include" X11LIB="$LFS/usr/lib" \
        FREETYPEINC="$LFS/usr/include/freetype2" \
        DESTDIR="$LFS" PREFIX=/usr install
    touch "$STAMPS/st"
    cd "$ROOT"
    echo "st hazir"
fi

build_autotools xinit "$XINIT_SRC" tar.xz "--with-xinitdir=/etc/X11/xinit"

cat > "$LFS/etc/X11/xinit/xinitrc" <<'EOF'
exec dwm
EOF
chmod +x "$LFS/etc/X11/xinit/xinitrc"
