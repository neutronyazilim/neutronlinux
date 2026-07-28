#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kcoreaddons" ] || { echo "once scripts/60-kf6-kcoreaddons.sh calistirin" >&2; exit 1; }
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

build_kf6 kconfig "$KCONFIG_SRC" -DKCONFIG_USE_QML=ON
build_kf6 kwidgetsaddons "$KWIDGETSADDONS_SRC"
build_kf6 kguiaddons "$KGUIADDONS_SRC" -DWITH_WAYLAND=OFF
build_kf6 ki18n "$KI18N_SRC" -DBUILD_WITH_QML=ON
build_kf6 kcodecs "$KCODECS_SRC" -DBUILD_PYTHON_BINDINGS=OFF
build_kf6 karchive "$KARCHIVE_SRC" -DWITH_BZIP2=OFF -DWITH_OPENSSL=OFF -DWITH_LIBZSTD=OFF
build_kf6 kitemviews "$KITEMVIEWS_SRC"
build_kf6 kitemmodels "$KITEMMODELS_SRC"
build_kf6 kdbusaddons "$KDBUSADDONS_SRC"
build_kf6 kwindowsystem "$KWINDOWSYSTEM_SRC" -DKWINDOWSYSTEM_QML=ON -DKWINDOWSYSTEM_WAYLAND=ON -DKWINDOWSYSTEM_X11=ON
build_kf6 solid "$SOLID_SRC"
