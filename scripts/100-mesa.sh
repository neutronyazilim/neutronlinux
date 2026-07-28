#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/mesa" ] && { echo "mesa zaten derlenmis, atlaniyor"; exit 0; }
for dep in libglvnd libdrm wayland wayland-protocols libxcb libX11 libXext \
           libXdamage libxshmfence libXxf86vm libXrandr expat zstd llvm libelf; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep derlenmeli" >&2; exit 1; }
done

[ -d "$BUILD/$MESA_SRC" ] || tar -xf "$SOURCES/$MESA_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$MESA_SRC"

sed -i "s/if cc.links('static char unused() { return 5; } int main() { return 0; }',/if false and cc.links('static char unused() { return 5; } int main() { return 0; }',/" meson.build

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" \
    --prefix=/usr --buildtype=release \
    -Dcpp_rtti=true \
    -Dplatforms=x11,wayland \
    -Degl-native-platform=x11 \
    -Dgallium-drivers=llvmpipe,crocus,iris,radeonsi,r600,nouveau \
    -Dvulkan-drivers= \
    -Dllvm=enabled \
    -Dshared-llvm=enabled \
    -Degl=enabled \
    -Dgbm=enabled \
    -Dglx=dri \
    -Dopengl=true \
    -Dgles1=disabled \
    -Dgles2=enabled \
    -Dglvnd=enabled \
    -Dgallium-va=disabled \
    -Dvideo-codecs= \
    -Dtools= \
    -Dvalgrind=disabled \
    -Dlibunwind=disabled \
    -Dselinux=false \
    -Dbuild-tests=false \
    -Dzstd=enabled \
    -Dzlib=enabled
ninja -C build -j4
DESTDIR="$LFS" ninja -C build install

mkdir -p "$LFS/usr/share/glvnd/glx_vendor.d"
cat > "$LFS/usr/share/glvnd/glx_vendor.d/mesa.json" <<'EOF'
{
    "file_format_version" : "1.0.0",
    "ICD" : {
        "library_path" : "libGLX_mesa.so.0"
    }
}
EOF

touch "$STAMPS/mesa"
echo "mesa hazir"
