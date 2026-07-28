#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/nss" ] && { echo "nss zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/nspr" ] || { echo "once scripts/160-nspr.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/sqlite" ] || { echo "once sqlite icin ilgili scripti calistirin" >&2; exit 1; }

GYP_VENV="$BUILD/gyp-venv"
[ -x "$GYP_VENV/bin/gyp" ] || { python3 -m venv "$GYP_VENV"; "$GYP_VENV/bin/pip" install gyp-next >/dev/null; }

[ -d "$BUILD/$NSS_SRC" ] || tar -xf "$SOURCES/$NSS_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$NSS_SRC/nss"

PATH="$GYP_VENV/bin:$PATH" \
CC="$TARGET-gcc" CCC="$TARGET-g++" CXX="$TARGET-g++" \
./build.sh --opt --disable-tests --system-sqlite \
    --with-nspr="$LFS/usr/include/nspr:$LFS/usr/lib" \
    -j "$JOBS"

DIST="$BUILD/$NSS_SRC/dist"
install -d "$LFS/usr/lib" "$LFS/usr/include/nss" "$LFS/usr/lib/pkgconfig" "$LFS/usr/bin"
install -m755 "$DIST/Release/lib/"*.so "$LFS/usr/lib/"
cp -r "$DIST/public/nss/." "$LFS/usr/include/nss/"
for prog in certutil pk12util crlutil modutil signtool cmsutil ssltap; do
    [ -f "$DIST/Release/bin/$prog" ] && install -m755 "$DIST/Release/bin/$prog" "$LFS/usr/bin/"
done

sed -e "s|%prefix%|/usr|" -e "s|%exec_prefix%|/usr|" \
    -e "s|%libdir%|/usr/lib|" -e "s|%includedir%|/usr/include/nss|" \
    -e "s|%NSS_VERSION%|$NSS_VER|" -e "s|%NSPR_VERSION%|$NSPR_VER|" \
    pkg/pkg-config/nss.pc.in > "$LFS/usr/lib/pkgconfig/nss.pc"

touch "$STAMPS/nss"
echo "nss hazir"
