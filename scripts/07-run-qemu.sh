#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

command -v qemu-system-x86_64 >/dev/null || {
    echo "qemu-system-x86_64 bulunamadi. CachyOS/Arch: sudo pacman -S qemu-system-x86" >&2
    exit 1
}
[ -f "$OUTPUT/bzImage" ] || { echo "$OUTPUT/bzImage yok, once scripts/04-kernel.sh calistirin" >&2; exit 1; }
[ -f "$OUTPUT/initramfs.cpio.gz" ] || { echo "$OUTPUT/initramfs.cpio.gz yok, once scripts/06-image.sh calistirin" >&2; exit 1; }

exec qemu-system-x86_64 \
    -kernel "$OUTPUT/bzImage" \
    -initrd "$OUTPUT/initramfs.cpio.gz" \
    -append "console=ttyS0" \
    -nographic \
    -m 512M
