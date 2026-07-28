#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libxcb" ] || { echo "once scripts/49-libxcb.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/libxml2" ] || { echo "once scripts/128-libxml2.sh calistirin" >&2; exit 1; }

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

build_autotools xcb-util "$XCBUTIL_SRC" ""
build_autotools xcb-util-image "$XCBUTILIMAGE_SRC" ""
build_autotools xcb-util-renderutil "$XCBUTILRENDERUTIL_SRC" ""
build_autotools xcb-util-cursor "$XCBUTILCURSOR_SRC" ""
build_autotools xcb-util-wm "$XCBUTILWM_SRC" ""
build_autotools xcb-util-keysyms "$XCBUTILKEYSYMS_SRC" ""

if [ -f "$STAMPS/libxkbcommon" ]; then
    echo "libxkbcommon zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$LIBXKBCOMMON_SRC" ] || tar -xf "$SOURCES/libxkbcommon-$LIBXKBCOMMON_VER.tar.gz" -C "$BUILD"
    cd "$BUILD/$LIBXKBCOMMON_SRC"
    rm -rf build
    ICU_PC="$LFS/usr/lib/pkgconfig/icu-uc.pc"
    [ -f "$ICU_PC" ] && mv "$ICU_PC" "$ICU_PC.hidden"
    meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dbuildtype=release \
        -Dxkb-config-root=/usr/share/X11/xkb \
        -Denable-x11=true -Denable-wayland=false -Denable-docs=false \
        -Denable-xkbregistry=true
    [ -f "$ICU_PC.hidden" ] && mv "$ICU_PC.hidden" "$ICU_PC"
    ninja -C build
    DESTDIR="$LFS" ninja -C build install
    touch "$STAMPS/libxkbcommon"
    cd "$ROOT"
    echo "libxkbcommon hazir"
fi
