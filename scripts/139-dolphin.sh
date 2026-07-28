#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/dolphin" ] && { echo "dolphin zaten derlenmis, atlaniyor"; exit 0; }
for dep in kcmutils knewstuff kcoreaddons ki18n kdbusaddons kbookmarks \
           kconfig kio kparts solid kiconthemes kcompletion ktextwidgets \
           knotifications kcrash kwindowsystem kwidgetsaddons kcodecs \
           kguiaddons kcolorscheme kfilemetadata; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$DOLPHIN_SRC" ] || tar -xf "$SOURCES/$DOLPHIN_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$DOLPHIN_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/dolphin"
echo "dolphin hazir"
