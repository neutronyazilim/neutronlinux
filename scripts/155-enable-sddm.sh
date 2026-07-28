#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/enable-sddm" ] && { echo "sddm zaten etkin, atlaniyor"; exit 0; }
[ -f "$STAMPS/sddm" ] || { echo "once scripts/154-sddm.sh calistirin" >&2; exit 1; }

mkdir -p "$LFS/etc/systemd/system"
ln -sfn /usr/lib/systemd/system/graphical.target "$LFS/etc/systemd/system/default.target"
ln -sfn /usr/lib/systemd/system/sddm.service "$LFS/etc/systemd/system/display-manager.service"

touch "$STAMPS/enable-sddm"
echo "sddm etkinlestirildi (default.target -> graphical.target)"
