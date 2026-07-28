#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/libparted" ] && { echo "libparted ready"; exit 0; }

[ -d "$BUILD/parted-3.6" ] || {
    wget -q -O /tmp/parted.tar.gz https://git.savannah.gnu.org/cgit/parted.git/snapshot/parted-3.6.tar.gz
    tar -xf /tmp/parted.tar.gz -C "$BUILD"
}

cd "$BUILD/parted-3.6"
export PATH="/mnt/data/heryarrak/neutronlinux/sysroot/tools/bin:$PATH"
./configure --host="$TARGET" --prefix=/usr --disable-static --disable-nls
make -j"$JOBS"
make DESTDIR="$LFS" install
touch "$STAMPS/libparted"
echo "libparted ready"
