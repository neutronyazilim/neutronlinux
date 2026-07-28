#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/quark" ] && { echo "quark zaten derlenmis, atlaniyor"; exit 0; }
command -v go >/dev/null || { echo "host'ta go yok: sudo pacman -S go" >&2; exit 1; }

cd "$ROOT/quark"
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o "$BUILD/quark-bin" ./cmd/quark
cd "$ROOT"

file "$BUILD/quark-bin" | grep -q "statically linked" || \
    { echo "quark statik derlenmedi - CGO_ENABLED sizmis olabilir" >&2; exit 1; }

install -Dm755 "$BUILD/quark-bin" "$LFS/usr/bin/quark"
mkdir -p "$LFS/etc/quark"
[ -f "$LFS/etc/quark/quark.conf" ] || install -Dm644 "$ROOT/quark/quark.conf.example" "$LFS/etc/quark/quark.conf"

touch "$STAMPS/quark"
echo "quark hazir: $LFS/usr/bin/quark"
file "$LFS/usr/bin/quark"
