#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

need=(gcc g++ make bison gawk m4 patch tar xz wget bc python3 perl)
missing=()
for cmd in "${need[@]}"; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done

if [ "${#missing[@]}" -ne 0 ]; then
    echo "Eksik host araclari: ${missing[*]}" >&2
    echo "CachyOS/Arch: sudo pacman -S base-devel bison gawk m4 wget bc python perl" >&2
    exit 1
fi

echo "Host hazir. gcc: $(gcc --dumpversion), make: $(make --version | head -1)"
