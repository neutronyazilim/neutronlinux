#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/solid" ] || { echo "once scripts/61-kf6-tier1.sh calistirin" >&2; exit 1; }
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

build_kf6 kcolorscheme "$KCOLORSCHEME_SRC"
build_kf6 kconfigwidgets "$KCONFIGWIDGETS_SRC"
build_kf6 kcompletion "$KCOMPLETION_SRC"
build_kf6 kcrash "$KCRASH_SRC"
build_kf6 kglobalaccel "$KGLOBALACCEL_SRC"
build_kf6 attica "$ATTICA_SRC"
build_kf6 breeze-icons "$BREEZEICONS_SRC" -DWITH_ICON_GENERATION=OFF
build_kf6 kiconthemes "$KICONTHEMES_SRC" -DKICONTHEMES_USE_QTQUICK=OFF -DBUILD_DESIGNERPLUGIN=OFF
build_kf6 kservice "$KSERVICE_SRC"
[ -f "$STAMPS/knotifications" ] || {
    [ -d "$BUILD/$KNOTIFICATIONS_SRC" ] || tar -xf "$SOURCES/$KNOTIFICATIONS_SRC.tar.xz" -C "$BUILD"
    sed -i 's/find_package(Canberra REQUIRED)/find_package(Canberra)/' \
        "$BUILD/$KNOTIFICATIONS_SRC/CMakeLists.txt"
}
build_kf6 knotifications "$KNOTIFICATIONS_SRC"
build_kf6 kjobwidgets "$KJOBWIDGETS_SRC"
build_kf6 sonnet "$SONNET_SRC" -DSONNET_USE_QML=OFF -DSONNET_NO_BACKENDS=ON
build_kf6 kpackage "$KPACKAGE_SRC"
