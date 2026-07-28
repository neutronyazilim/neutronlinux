#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/calamares" ] && { echo "calamares zaten derlenmis, atlaniyor"; exit 0; }

for dep in kcoreaddons kconfig kio kparts kdeclarative; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

if [ ! -d "$BUILD/$CALAMARES_SRC" ]; then
    if [ ! -f "$SOURCES/$CALAMARES_SRC.tar.gz" ]; then
        echo "Downloading Calamares..."
        wget -q -O "$SOURCES/$CALAMARES_SRC.tar.gz" \
            "https://github.com/calamares/calamares/releases/download/v$CALAMARES_VER/calamares-$CALAMARES_VER.tar.gz" || \
            { echo "Download failed"; exit 1; }
    fi
    tar -xf "$SOURCES/$CALAMARES_SRC.tar.gz" -C "$BUILD"
fi
cd "$BUILD/$CALAMARES_SRC"

mkdir -p build
cd build
cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DWITH_QT6=ON \
    -DQt6_DIR="$LFS/usr/lib/cmake/Qt6" \
    -DSKIP_MODULES="bootloader grubcfg" \
    -DCMAKE_DISABLE_FIND_PACKAGE_PolkitQt6-1=ON \
    ..

ninja -j"$JOBS"
DESTDIR="$LFS" ninja install

touch "$STAMPS/calamares"
echo "calamares hazir"
