#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kirigami-addons" ] && { echo "kirigami-addons zaten derlenmis, atlaniyor"; exit 0; }
for dep in kirigami ki18n kconfig kcoreaddons kguiaddons kcolorscheme kcrash kiconthemes kglobalaccel; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$KIRIGAMIADDONS_SRC" ] || tar -xf "$SOURCES/$KIRIGAMIADDONS_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$KIRIGAMIADDONS_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF \
    -DBUILD_EXAMPLES=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/kirigami-addons"
echo "kirigami-addons hazir"
