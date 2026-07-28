#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/llvm" ] && { echo "llvm zaten derlenmis, atlaniyor"; exit 0; }
for dep in zlib zstd libxml2; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep derlenmeli" >&2; exit 1; }
done
command -v llvm-tblgen >/dev/null || { echo "host'ta llvm-tblgen bulunamadi (pacman -S llvm)" >&2; exit 1; }
NATIVE_TBLGEN="$(command -v llvm-tblgen)"

[ -d "$BUILD/$LLVM_SRC/llvm" ] || tar -xf "$SOURCES/$LLVM_SRC.tar.xz" -C "$BUILD" \
    "$LLVM_SRC/llvm" "$LLVM_SRC/cmake" "$LLVM_SRC/third-party"
cd "$BUILD/$LLVM_SRC"

rm -rf build
cmake -S llvm -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DLLVM_TABLEGEN="$NATIVE_TBLGEN" \
    -DLLVM_TARGETS_TO_BUILD="X86;AMDGPU;SPIRV" \
    -DLLVM_BUILD_LLVM_DYLIB=ON \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_ENABLE_BINDINGS=OFF \
    -DLLVM_ENABLE_TERMINFO=OFF \
    -DLLVM_ENABLE_LIBEDIT=OFF \
    -DLLVM_ENABLE_LTO=OFF \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_ENABLE_ZLIB=FORCE_ON \
    -DLLVM_ENABLE_ZSTD=FORCE_ON \
    -DLLVM_ENABLE_LIBXML2=FORCE_ON \
    -DLLVM_PARALLEL_LINK_JOBS=1 \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
ninja -C build -j4
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/llvm"
echo "llvm hazir"
