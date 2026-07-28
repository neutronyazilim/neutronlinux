#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/plasma-desktop" ] && { echo "plasma-desktop zaten derlenmis, atlaniyor"; exit 0; }
for dep in plasma-workspace plasma5support kwin kdecoration; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$PLASMADESKTOP_SRC" ] || tar -xf "$SOURCES/$PLASMADESKTOP_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$PLASMADESKTOP_SRC"

sed -i "s/^find_package(KWinDBusInterface CONFIG REQUIRED)/find_package(KWinX11DBusInterface CONFIG REQUIRED)/" \
    CMakeLists.txt

sed -i "s/^add_subdirectory(touchscreen)/# add_subdirectory(touchscreen)  # ponytail: needs kwin's Wayland-only InputDevice DBus interface/" \
    kcms/CMakeLists.txt

sed -i 's|if (NOT EXISTS "${CMAKE_SYSROOT}/${XKBDIR}")|if (NOT EXISTS "${XKBDIR}")|' \
    ConfigureChecks.cmake

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF \
    -DBUILD_KCM_TABLET=OFF \
    -DBUILD_KCM_MOUSE_X11=OFF \
    -DBUILD_KCM_MOUSE_KWIN_WAYLAND=OFF \
    -DBUILD_KCM_TOUCHPAD_X11=OFF \
    -DBUILD_KCM_TOUCHPAD_KWIN_WAYLAND=OFF \
    -DBUILD_DOC=OFF
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/plasma-desktop"
echo "plasma-desktop hazir"
