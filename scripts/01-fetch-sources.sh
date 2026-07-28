#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

cd "$SOURCES"
touch SHA256SUMS

echo "$SOURCES_LIST" | while read -r name url; do
    [ -z "$name" ] && continue
    if [ -f "$name" ]; then
        echo "verify $name"
        grep -q " $name\$" SHA256SUMS && sha256sum -c <(grep " $name\$" SHA256SUMS)
        continue
    fi
    echo "fetch $name <- $url"
    wget -c -O "$name.part" "$url"
    mv "$name.part" "$name"
    sha256sum "$name" >> SHA256SUMS
done

echo "Tum kaynaklar $SOURCES altinda."
