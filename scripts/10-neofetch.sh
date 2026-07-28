#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

[ -x "$LFS/usr/bin/bash" ] || { echo "bash yok, once scripts/09-bash.sh calistirin" >&2; exit 1; }

NEOFETCH_URL="https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch"
NEOFETCH_SRC="$SOURCES/neofetch"

if [ ! -f "$NEOFETCH_SRC" ]; then
    wget -O "$NEOFETCH_SRC.part" "$NEOFETCH_URL"
    mv "$NEOFETCH_SRC.part" "$NEOFETCH_SRC"
fi

install -Dm755 "$NEOFETCH_SRC" "$LFS/usr/bin/neofetch"
sed -i '1s|^#!.*|#!/usr/bin/bash|' "$LFS/usr/bin/neofetch"

echo "neofetch hazir: $LFS/usr/bin/neofetch"
