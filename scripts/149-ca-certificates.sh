#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/ca-certificates" ] && { echo "ca-certificates zaten kurulu, atlaniyor"; exit 0; }

BUNDLE="$SOURCES/cacert.pem"
[ -f "$BUNDLE" ] || curl -sL "https://curl.se/ca/cacert.pem" -o "$BUNDLE"
[ -s "$BUNDLE" ] || { echo "cacert.pem indirilemedi" >&2; exit 1; }

install -Dm644 "$BUNDLE" "$LFS/etc/ssl/certs/ca-certificates.crt"
ln -sf ca-certificates.crt "$LFS/etc/ssl/cert.pem"

touch "$STAMPS/ca-certificates"
echo "ca-certificates hazir"
