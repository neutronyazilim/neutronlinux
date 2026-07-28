#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/sddm" ] && { echo "sddm zaten derlenmis, atlaniyor"; exit 0; }
for dep in pam libxcb qtdeclarative qtsvg qttools systemd; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$SDDM_SRC" ] || tar -xf "$SOURCES/$SDDM_SRC.tar.gz" -C "$BUILD"
cd "$BUILD/$SDDM_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
rm -rf build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DBUILD_WITH_QT6=ON \
    -DBUILD_MAN_PAGES=OFF \
    -DNO_SYSTEMD=OFF \
    -DUSE_ELOGIND=OFF \
    -DENABLE_JOURNALD=ON \
    -DINSTALL_PAM_CONFIGURATION=ON \
    -DCMAKE_INSTALL_SYSCONFDIR=/etc \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/sddm"
echo "sddm hazir"
