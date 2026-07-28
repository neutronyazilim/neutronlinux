#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/branding-logo" ] && { echo "logo zaten kurulu, atlaniyor"; exit 0; }

for size in 48 64 128 256 512; do
    install -d "$LFS/usr/share/icons/hicolor/${size}x${size}/apps"
    convert "scripts/assets/neutronlinux-logo.png" -resize "${size}x${size}" \
        "$LFS/usr/share/icons/hicolor/${size}x${size}/apps/distributor-logo-neutronlinux.png"
done

grep -q '^LOGO=' "$LFS/etc/os-release" 2>/dev/null || \
    echo "LOGO=distributor-logo-neutronlinux" >> "$LFS/etc/os-release"

touch "$STAMPS/branding-logo"
echo "logo kuruldu"
