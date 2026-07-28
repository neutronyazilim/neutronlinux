#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kpackage" ] || { echo "once scripts/62-kf6-tier2.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/qtdeclarative" ] || { echo "once scripts/58d-qtdeclarative.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/qrencode" ] || { echo "once scripts/63a-qrencode.sh calistirin" >&2; exit 1; }
TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"

build_kf6() {
    local name="$1" src="$2"; shift 2
    [ -f "$STAMPS/$name" ] && { echo "$name zaten derlenmis, atlaniyor"; return; }
    [ -d "$BUILD/$src" ] || tar -xf "$SOURCES/$src.tar.xz" -C "$BUILD"
    cd "$BUILD/$src"
    rm -rf build
    cmake -S . -B build -G Ninja \
        -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DQT_HOST_PATH=/usr \
        -DBUILD_TESTING=OFF \
        -DBUILD_QCH=OFF \
        -DBUILD_PYTHON_BINDINGS=OFF \
        "$@"
    ninja -C build
    DESTDIR="$LFS" ninja -C build install
    touch "$STAMPS/$name"
    cd "$ROOT"
    echo "$name hazir"
}

build_kf6 kunitconversion "$KUNITCONVERSION_SRC"
build_kf6 prison "$PRISON_SRC" -DWITH_MULTIMEDIA=OFF -DWITH_DMTX=OFF -DWITH_ZXING=OFF
build_kf6 kdeclarative "$KDECLARATIVE_SRC"
build_kf6 kxmlgui "$KXMLGUI_SRC"
build_kf6 ktextwidgets "$KTEXTWIDGETS_SRC" -DWITH_TEXT_TO_SPEECH=OFF
build_kf6 kio "$KIO_SRC" -DWITH_X11=ON -DWITH_WAYLAND=OFF -DBUILD_DESIGNERPLUGIN=OFF
build_kf6 kcmutils "$KCMUTILS_SRC"
