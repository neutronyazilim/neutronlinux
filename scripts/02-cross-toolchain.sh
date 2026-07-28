#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"

done_() { [ -f "$STAMPS/$1" ]; }
mark() { touch "$STAMPS/$1"; }

extract() {
    local tarball="$1" dir="$BUILD/$2"
    [ -d "$dir" ] && return
    echo "extract $tarball"
    tar -xf "$SOURCES/$tarball" -C "$BUILD"
}

if ! done_ binutils-pass1; then
    extract "$BINUTILS_SRC.tar.xz" "$BINUTILS_SRC"
    rm -rf "$BUILD/binutils-pass1-build"; mkdir -p "$BUILD/binutils-pass1-build"
    cd "$BUILD/binutils-pass1-build"
    "$BUILD/$BINUTILS_SRC/configure" \
        --prefix="$TOOLS" --with-sysroot="$LFS" --target="$TARGET" \
        --disable-nls --disable-werror --enable-gprofng=no
    make
    make install
    mark binutils-pass1
    cd "$ROOT"
fi

if ! done_ linux-headers; then
    extract "$LINUX_SRC.tar.xz" "$LINUX_SRC"
    cd "$BUILD/$LINUX_SRC"
    make mrproper
    make headers_install ARCH=x86_64 INSTALL_HDR_PATH="$LFS/usr"
    mark linux-headers
    cd "$ROOT"
fi

if ! done_ gcc-pass1; then
    extract "$GCC_SRC.tar.xz" "$GCC_SRC"
    cd "$BUILD/$GCC_SRC"
    ./contrib/download_prerequisites
    cd "$ROOT"
    rm -rf "$BUILD/gcc-pass1-build"; mkdir -p "$BUILD/gcc-pass1-build"
    cd "$BUILD/gcc-pass1-build"
    "$BUILD/$GCC_SRC/configure" \
        --target="$TARGET" --prefix="$TOOLS" --with-sysroot="$LFS" \
        --with-glibc-version="$GLIBC_VER" --with-newlib --without-headers \
        --enable-default-pie --enable-default-ssp \
        --disable-nls --disable-shared --disable-multilib --disable-threads \
        --disable-libatomic --disable-libgomp --disable-libquadmath \
        --disable-libssp --disable-libvtv --disable-libstdcxx \
        --disable-libsanitizer --enable-languages=c,c++
    make
    make install
    mark gcc-pass1
    cd "$ROOT"
fi

if ! done_ glibc; then
    extract "$GLIBC_SRC.tar.xz" "$GLIBC_SRC"
    rm -rf "$BUILD/glibc-build"; mkdir -p "$BUILD/glibc-build"
    cd "$BUILD/glibc-build"
    BUILD_TRIPLET="$("$BUILD/$GLIBC_SRC/scripts/config.guess")"
    "$BUILD/$GLIBC_SRC/configure" \
        --prefix=/usr --host="$TARGET" --build="$BUILD_TRIPLET" \
        --enable-kernel=4.19 --with-headers="$LFS/usr/include" \
        libc_cv_slibdir=/usr/lib
    make
    make DESTDIR="$LFS" install
    install -Dm755 elf/ldconfig "$LFS/usr/bin/ldconfig"
    mark glibc
    cd "$ROOT"
fi

if ! done_ gcc-pass2; then
    rm -rf "$BUILD/gcc-pass2-build"; mkdir -p "$BUILD/gcc-pass2-build"
    cd "$BUILD/gcc-pass2-build"
    "$BUILD/$GCC_SRC/configure" \
        --target="$TARGET" --prefix="$TOOLS" --with-sysroot="$LFS" \
        --enable-languages=c,c++ --disable-multilib --disable-nls \
        --disable-libstdcxx-pch --disable-libsanitizer \
        --with-gxx-include-dir="$TOOLS/$TARGET/include/c++/$GCC_VER"
    make
    make install
    mark gcc-pass2
    cd "$ROOT"
fi

echo "Cross toolchain hazir: $TOOLS/bin/$TARGET-gcc"
"$TOOLS/bin/$TARGET-gcc" --version | head -1
