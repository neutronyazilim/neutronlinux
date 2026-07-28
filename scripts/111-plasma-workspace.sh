#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/plasma-workspace" ] && { echo "plasma-workspace zaten derlenmis, atlaniyor"; exit 0; }
for dep in qcoro kwayland plasma-activities plasma-activities-stats libkscreen \
           layer-shell-qt kscreenlocker plasma-wayland-protocols wayland \
           icu knighttime kwin kdecoration kirigami libplasma; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$PLASMAWORKSPACE_SRC" ] || tar -xf "$SOURCES/$PLASMAWORKSPACE_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$PLASMAWORKSPACE_SRC"

sed -i "s/^find_package(KWinDBusInterface CONFIG REQUIRED)/find_package(KWinX11DBusInterface CONFIG REQUIRED)/" \
    CMakeLists.txt

sed -i "s/^    find_package(KF6NetworkManagerQt \${KF6_MIN_VERSION} CONFIG REQUIRED)/    find_package(KF6NetworkManagerQt \${KF6_MIN_VERSION} CONFIG)/" \
    CMakeLists.txt

sed -i "s/^add_subdirectory(keyboardlayout)/# add_subdirectory(keyboardlayout)  # ponytail: needs kwin's Wayland-only VirtualKeyboard.mode DBus property, not in kwin-x11's interface/" \
    components/CMakeLists.txt

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF \
    -DGLIBC_LOCALE_GEN=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/plasma-workspace"
echo "plasma-workspace hazir"
