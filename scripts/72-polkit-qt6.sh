#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/polkit-qt6" ] && { echo "polkit-qt6 ready"; exit 0; }

cd "$BUILD/polkit-qt-1-0.200.0"
rm -rf build && mkdir -p build && cd build
cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake" \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
    -DQt6_DIR="$LFS/usr/lib/cmake/Qt6" \
    -DBUILD_SHARED_LIBS=ON ..
ninja -j"$JOBS"
DESTDIR="$LFS" ninja install
touch "$STAMPS/polkit-qt6"
echo "polkit-qt6 ready"
