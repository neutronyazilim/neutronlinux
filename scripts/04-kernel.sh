#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/kernel" ] && { echo "kernel zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$LINUX_SRC" ] || tar -xf "$SOURCES/$LINUX_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$LINUX_SRC"

make ARCH=x86_64 CROSS_COMPILE="$TARGET-" defconfig

./scripts/config --enable FB --enable FB_SIMPLE --enable SYSFB_SIMPLEFB \
    --enable FRAMEBUFFER_CONSOLE --enable DRM_SIMPLEDRM

./scripts/config --enable DRM_FBDEV_EMULATION

./scripts/config --enable DRM_BOCHS --enable DRM_CIRRUS_QEMU --enable DRM_VIRTIO_GPU

./scripts/config --enable DRM_VMWGFX

./scripts/config --enable EXPERT
./scripts/config --disable VGA_CONSOLE --disable DRM_I915

./scripts/config --enable USER_NS
make ARCH=x86_64 CROSS_COMPILE="$TARGET-" olddefconfig

make ARCH=x86_64 CROSS_COMPILE="$TARGET-" bzImage

cp arch/x86/boot/bzImage "$OUTPUT/bzImage"
touch "$STAMPS/kernel"
echo "Kernel hazir: $OUTPUT/bzImage"
