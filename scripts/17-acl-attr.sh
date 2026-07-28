#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/acl-attr" ] && { echo "acl/attr zaten derlenmis, atlaniyor"; exit 0; }

build_autotools() {
    local src="$1" tarball="$2"
    [ -d "$BUILD/$src" ] || tar -xf "$SOURCES/$tarball" -C "$BUILD"
    cd "$BUILD/$src"
    BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
    ./configure \
        --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
        CC="$TARGET-gcc" \
        --disable-static
    make
    make DESTDIR="$LFS" install
    cd "$ROOT"
}

build_autotools "$ATTR_SRC" "$ATTR_SRC.tar.gz"
build_autotools "$ACL_SRC" "$ACL_SRC.tar.xz"

touch "$STAMPS/acl-attr"
echo "acl/attr hazir"
