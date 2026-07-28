#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

[ -f "$OUTPUT/initramfs.cpio.gz" ] || { echo "$OUTPUT/initramfs.cpio.gz yok, once scripts/06-image.sh calistirin" >&2; exit 1; }
[ -d "$BUILD/$LINUX_SRC" ] || { echo "$BUILD/$LINUX_SRC yok, once scripts/04-kernel.sh calistirin" >&2; exit 1; }

cd "$BUILD/$LINUX_SRC"
./scripts/config --set-str INITRAMFS_SOURCE "$OUTPUT/initramfs.cpio.gz"
make ARCH=x86_64 CROSS_COMPILE="$TARGET-" olddefconfig
make ARCH=x86_64 CROSS_COMPILE="$TARGET-" bzImage

cp arch/x86/boot/bzImage "$OUTPUT/bzImage-embedded"

./scripts/config --set-str INITRAMFS_SOURCE ""

echo "gomulu kernel hazir: $OUTPUT/bzImage-embedded"
ls -lh "$OUTPUT/bzImage-embedded"
