#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/xf86-input-evdev" ] && { echo "xf86-input-evdev zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/xorg-server" ] || { echo "once scripts/53-xorg-server.sh calistirin" >&2; exit 1; }

if [ -f "$STAMPS/mtdev" ]; then
    echo "mtdev zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$MTDEV_SRC" ] || tar -xf "$SOURCES/$MTDEV_SRC.tar.bz2" -C "$BUILD"
    cd "$BUILD/$MTDEV_SRC"
    CG="$(find . -maxdepth 2 -name config.guess | head -1)"
    chmod +x "$CG"
    BUILD_TRIPLET="$("$CG")"
    ./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"
    make
    make DESTDIR="$LFS" install
    find "$LFS" -name '*.la' -delete
    touch "$STAMPS/mtdev"
    cd "$ROOT"
    echo "mtdev hazir"
fi

if [ -f "$STAMPS/libevdev" ]; then
    echo "libevdev zaten derlenmis, atlaniyor"
else
    [ -d "$BUILD/$LIBEVDEV_SRC" ] || tar -xf "$SOURCES/$LIBEVDEV_SRC.tar.xz" -C "$BUILD"
    cd "$BUILD/$LIBEVDEV_SRC"
    rm -rf build
    meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dbuildtype=release \
        -Dtests=disabled -Ddocumentation=disabled
    ninja -C build
    DESTDIR="$LFS" ninja -C build install
    touch "$STAMPS/libevdev"
    cd "$ROOT"
    echo "libevdev hazir"
fi

[ -d "$BUILD/$XF86INPUTEVDEV_SRC" ] || tar -xf "$SOURCES/$XF86INPUTEVDEV_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$XF86INPUTEVDEV_SRC"
chmod +x config.guess build-aux/config.guess 2>/dev/null || true
BUILD_TRIPLET="$([ -x ./config.guess ] && ./config.guess || build-aux/config.guess)"
./configure --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr CC="$TARGET-gcc"
make
make DESTDIR="$LFS" install
find "$LFS" -name '*.la' -delete

touch "$STAMPS/xf86-input-evdev"
echo "xf86-input-evdev hazir"
