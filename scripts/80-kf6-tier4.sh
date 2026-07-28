#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kcmutils" ] || { echo "once scripts/63-kf6-tier3.sh calistirin" >&2; exit 1; }
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

build_kf6 kauth "$KAUTH_SRC"
build_kf6 kidletime "$KIDLETIME_SRC"
build_kf6 kded "$KDED_SRC"
build_kf6 kholidays "$KHOLIDAYS_SRC"
build_kf6 kparts "$KPARTS_SRC"
build_kf6 krunner "$KRUNNER_SRC"
build_kf6 knewstuff "$KNEWSTUFF_SRC"
build_kf6 kwallet "$KWALLET_SRC"
build_kf6 syntax-highlighting "$SYNTAXHIGHLIGHTING_SRC"
[ -f "$STAMPS/qtspeech" ] || { echo "once scripts/79-qtspeech.sh calistirin" >&2; exit 1; }
build_kf6 ktexteditor "$KTEXTEDITOR_SRC"
