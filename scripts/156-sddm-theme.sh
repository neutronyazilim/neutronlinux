#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/sddm-theme" ] && { echo "sddm temasi zaten ayarlandi, atlaniyor"; exit 0; }
[ -d "$LFS/usr/share/sddm/themes/breeze" ] || { echo "sddm'in breeze temasi bulunamadi - once scripts/154-sddm.sh calistirin" >&2; exit 1; }

mkdir -p "$LFS/etc/sddm.conf.d"
cat > "$LFS/etc/sddm.conf.d/theme.conf" <<'EOF'
[Theme]
Current=breeze
EOF

rm -f "$LFS/usr/share/wayland-sessions/plasma.desktop"

touch "$STAMPS/sddm-theme"
echo "sddm temasi breeze olarak ayarlandi, wayland session kaldirildi"
