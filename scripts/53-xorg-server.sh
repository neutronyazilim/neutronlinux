#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/xorg-server" ] && { echo "xorg-server zaten derlenmis, atlaniyor"; exit 0; }
for dep in libX11 libxkbfile xkeyboard-config xkbcomp libdrm libpciaccess pixman libXfont2; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$XORGSERVER_SRC" ] || tar -xf "$SOURCES/$XORGSERVER_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$XORGSERVER_SRC"

sed -i "s|dri_dep.get_pkgconfig_variable('dridriverdir')|'/usr/lib/dri'|" \
    include/meson.build

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --prefix=/usr -Dbuildtype=release \
    -Dglamor=true -Dglx=true -Ddri1=false -Ddri2=true -Ddri3=true \
    -Dxephyr=false -Dxnest=false -Dxvfb=false -Dxwin=false -Dxquartz=false \
    -Dsystemd_logind=false -Dhal=false -Dxselinux=false \
    -Dint10=false -Dvgahw=false -Ddga=false -Dlinux_apm=false -Dlinux_acpi=false \
    -Dxdmcp=false -Dxdm-auth-1=false -Dsecure-rpc=false -Dsha1=libmd \
    -Ddocs=false -Ddevel-docs=false -Dsuid_wrapper=false \
    -Dudev=true -Dudev_kms=true -Ddrm=true -Dpciaccess=true \
    -Dxkb_default_rules=xorg -Dxorg=true \
    -Dxkb_dir=/usr/share/X11/xkb -Dxkb_bin_dir=/usr/bin
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/xorg-server"
echo "xorg-server hazir"
