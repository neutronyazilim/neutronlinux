#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/fastfetch" ] && { echo "fastfetch zaten derlenmis, atlaniyor"; exit 0; }

FASTFETCH_VER="2.66.0"
FASTFETCH_SRC="fastfetch-$FASTFETCH_VER"
[ -f "$SOURCES/$FASTFETCH_SRC.tar.gz" ] || \
    wget -q -O "$SOURCES/$FASTFETCH_SRC.tar.gz" \
        "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/$FASTFETCH_VER.tar.gz"
[ -d "$BUILD/$FASTFETCH_SRC" ] || tar -xf "$SOURCES/$FASTFETCH_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$FASTFETCH_SRC"

TOOLCHAIN_FILE="$BUILD/fastfetch-toolchain.cmake"
cat > "$TOOLCHAIN_FILE" <<EOF
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER $TARGET-gcc)
set(CMAKE_CXX_COMPILER $TARGET-g++)
set(CMAKE_FIND_ROOT_PATH $LFS)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOF

rm -rf build
cmake -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_VULKAN=OFF -DENABLE_WAYLAND=OFF -DENABLE_XCB_RANDR=OFF \
    -DENABLE_XRANDR=OFF -DENABLE_DRM=OFF -DENABLE_VADRM=OFF \
    -DENABLE_VAX11=OFF -DENABLE_VDPAU=OFF -DENABLE_GIO=OFF \
    -DENABLE_DCONF=OFF -DENABLE_EET=OFF -DENABLE_DBUS=OFF \
    -DENABLE_SQLITE3=OFF -DENABLE_RPM=OFF -DENABLE_IMAGEMAGICK7=OFF \
    -DENABLE_IMAGEMAGICK6=OFF -DENABLE_CHAFA=OFF -DENABLE_EGL=OFF \
    -DENABLE_GLX=OFF -DENABLE_OPENCL=OFF -DENABLE_FREETYPE=OFF \
    -DENABLE_PULSE=OFF -DENABLE_DDCUTIL=OFF -DENABLE_ELF=OFF \
    -DENABLE_ZLIB=OFF -DENABLE_LTO=OFF -DBUILD_TESTS=OFF \
    -DENABLE_LUA=OFF -DENABLE_QUICKJS=OFF

ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/fastfetch"
echo "fastfetch hazir"
file "$LFS/usr/bin/fastfetch"

mkdir -p "$LFS/etc/fastfetch"
cp "$ROOT/scripts/assets/neutronlinux-logo-color.txt" "$LFS/etc/fastfetch/neutronlinux-logo.txt"
cp "$ROOT/scripts/assets/fastfetch-config.jsonc" "$LFS/etc/fastfetch/config.jsonc"
