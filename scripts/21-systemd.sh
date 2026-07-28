#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/systemd" ] && { echo "systemd zaten derlenmis, atlaniyor"; exit 0; }
for dep in libxcrypt util-linux libcap acl-attr kmod pam dbus; do
    [ -f "$STAMPS/$dep" ] || { echo "once scripts icin $dep tamamlanmali" >&2; exit 1; }
done

[ -d "$BUILD/$SYSTEMD_SRC" ] || tar -xf "$SOURCES/$SYSTEMD_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$SYSTEMD_SRC"

rm -rf build
meson setup build \
    --cross-file="$MESON_CROSS" --prefix=/usr --libdir=/usr/lib \
    --sysconfdir=/etc --localstatedir=/var \
    -Dmode=release \
    -Ddefault-timeout-sec=5 \
    -Dman=disabled -Dhtml=disabled -Dtranslations=false \
    -Dtests=false -Dinstall-tests=false \
    -Defi=false -Dbootloader=disabled -Dukify=disabled \
    -Dbpf-framework=disabled \
    -Dpam=enabled -Ddbus=enabled -Dkmod=enabled -Dacl=enabled \
    -Dblkid=enabled -Dfdisk=enabled -Dlibmount=enabled -Dlibcrypt=enabled \
    -Dseccomp=disabled -Dselinux=disabled -Dapparmor=disabled -Dsmack=false \
    -Dpolkit=disabled -Dima=false -Dipe=false -Daudit=disabled \
    -Dpasswdqc=disabled -Dpwquality=disabled -Dmicrohttpd=disabled \
    -Dlibcryptsetup=disabled -Dlibcurl=disabled -Didn=false \
    -Dlibidn2=disabled -Dlibidn=disabled -Dlibiptc=disabled \
    -Dqrencode=disabled -Dgcrypt=disabled -Dgnutls=disabled \
    -Dopenssl=disabled -Dp11kit=disabled -Dlibfido2=disabled \
    -Dtpm2=disabled -Delfutils=disabled -Dzlib=disabled -Dbzip2=disabled \
    -Dxz=disabled -Dlz4=disabled -Dzstd=disabled -Dxkbcommon=disabled \
    -Dpcre2=disabled -Dglib=disabled -Dlibarchive=disabled \
    -Dxenctrl=disabled

ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/systemd"
echo "systemd hazir"
