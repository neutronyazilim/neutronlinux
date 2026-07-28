#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/busybox" ] && { echo "busybox zaten derlenmis, atlaniyor"; exit 0; }

[ -d "$BUILD/$BUSYBOX_SRC" ] || tar -xf "$SOURCES/$BUSYBOX_SRC.tar.bz2" -C "$BUILD"
cd "$BUILD/$BUSYBOX_SRC"

make ARCH=x86_64 CROSS_COMPILE="$TARGET-" defconfig
sed -i 's/^# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/^CONFIG_TC=y/# CONFIG_TC is not set/' .config
set +o pipefail
yes "" | make ARCH=x86_64 CROSS_COMPILE="$TARGET-" oldconfig >/dev/null
set -o pipefail

make ARCH=x86_64 CROSS_COMPILE="$TARGET-"
make ARCH=x86_64 CROSS_COMPILE="$TARGET-" CONFIG_PREFIX="$LFS" install

touch "$STAMPS/busybox"
echo "BusyBox hazir: $LFS/bin/busybox"
file "$LFS/bin/busybox"
