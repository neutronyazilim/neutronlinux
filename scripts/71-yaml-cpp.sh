#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/yaml-cpp" ] && { echo "yaml-cpp zaten derlenmis"; exit 0; }

[ -d "$BUILD/yaml-cpp-0.8.0" ] || {
    wget -q -O /tmp/yaml-cpp.tar.gz https://github.com/jbeder/yaml-cpp/archive/refs/tags/0.8.0.tar.gz
    tar -xf /tmp/yaml-cpp.tar.gz -C "$BUILD"
}

cd "$BUILD/yaml-cpp-0.8.0"
mkdir -p build && cd build
cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake" \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ..
ninja -j"$JOBS"
DESTDIR="$LFS" ninja install
touch "$STAMPS/yaml-cpp"
echo "yaml-cpp ready"
