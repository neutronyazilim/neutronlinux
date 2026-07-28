#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/pthread-stack-fix" ] && { echo "pthread-stack-fix zaten kurulmus, atlaniyor"; exit 0; }
[ -f "$STAMPS/glibc" ] || { echo "once glibc icin ilgili scripti calistirin" >&2; exit 1; }

mkdir -p "$LFS/usr/local/lib"
"$TOOLS/bin/$TARGET-gcc" --sysroot="$LFS" -shared -fPIC -O2 \
    -o "$LFS/usr/local/lib/pthread_stack_fix.so" \
    "$(dirname "${BASH_SOURCE[0]}")/134-pthread-stack-fix.c"

WRAPPER="$LFS/usr/local/bin/startplasma-x11-logged.sh"
if [ -f "$WRAPPER" ] && ! grep -q "pthread_stack_fix.so" "$WRAPPER"; then
    sed -i '/^exec /i export LD_PRELOAD=/usr/local/lib/pthread_stack_fix.so' "$WRAPPER"
fi

grep -qxF "/usr/local/lib/pthread_stack_fix.so" "$LFS/etc/ld.so.preload" 2>/dev/null || \
    echo "/usr/local/lib/pthread_stack_fix.so" >> "$LFS/etc/ld.so.preload"

touch "$STAMPS/pthread-stack-fix"
echo "pthread-stack-fix hazir"
