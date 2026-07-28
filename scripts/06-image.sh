#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

[ -x "$LFS/init" ] || { echo "$LFS/init yok, once scripts/05-rootfs.sh calistirin" >&2; exit 1; }

GEN_INIT_CPIO="$BUILD/$LINUX_SRC/usr/gen_init_cpio"
DEV_SPEC="$BUILD/dev-nodes.list"
cat > "$DEV_SPEC" <<'EOF'
dir /dev 0755 0 0
nod /dev/console 0600 0 0 c 5 1
nod /dev/null 0666 0 0 c 1 3
nod /dev/tty 0666 0 0 c 5 0
EOF

cd "$LFS"
{
    [ -x "$GEN_INIT_CPIO" ] && "$GEN_INIT_CPIO" "$DEV_SPEC"
    find . ! -path './tools*' ! -path './tools' ! -path './dev' | cpio -o -H newc -R 0:0 2>/dev/null
} | gzip -9 > "$OUTPUT/initramfs.cpio.gz"

echo "initramfs hazir: $OUTPUT/initramfs.cpio.gz"
ls -lh "$OUTPUT/initramfs.cpio.gz"
