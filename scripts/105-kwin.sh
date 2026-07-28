#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kwin" ] && { echo "kwin zaten derlenmis, atlaniyor"; exit 0; }
for dep in mesa libepoxy kdecoration kglobalacceld libdisplay-info \
           libxkbcommon wayland wayland-protocols plasma-wayland-protocols \
           libdrm libglvnd kscreenlocker plasma-activities knotifications \
           libXi libXdamage libxshmfence libXxf86vm; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$KWIN_SRC" ] || tar -xf "$SOURCES/$KWIN_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$KWIN_SRC"

sed -i "s/^add_subdirectory(systembell)/# add_subdirectory(systembell)/" \
    src/plugins/CMakeLists.txt
sed -i "s/^find_package(Canberra REQUIRED)/find_package(Canberra)/" \
    CMakeLists.txt

sed -i "s/^    Sensors$/    Sensors\n    OpenGL/" CMakeLists.txt
sed -i "s/^        Qt::Svg$/        Qt::Svg\n        Qt::OpenGL/" src/CMakeLists.txt

NATIVE_TOOLS="$BUILD/kwin-native-tools"
mkdir -p "$NATIVE_TOOLS"
if [ ! -x "$NATIVE_TOOLS/qtwaylandscanner_kde" ]; then
    g++ -std=c++20 -fPIC $(pkg-config --cflags Qt6Core) \
        src/wayland/tools/qtwaylandscanner.cpp \
        -o "$NATIVE_TOOLS/qtwaylandscanner_kde" \
        $(pkg-config --libs Qt6Core)
fi

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_TESTING=OFF \
    -DKWIN_BUILD_X11_BACKEND=ON \
    -DQTWAYLANDSCANNER_KDE_EXECUTABLE="$NATIVE_TOOLS/qtwaylandscanner_kde"
ninja -C build -j"$JOBS"
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/kwin"
echo "kwin hazir"
