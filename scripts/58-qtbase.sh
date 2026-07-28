#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/qtbase" ] && { echo "qtbase zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/libX11" ] || { echo "once scripts/50-libx11-libxext.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/openssl" ] || { echo "once scripts/58e-openssl.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/zstd" ] || { echo "once scripts/87-zstd.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/sqlite" ] || { echo "once scripts/90-sqlite.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/mesa" ] || { echo "once scripts/100-mesa.sh calistirin" >&2; exit 1; }
[ -f "$STAMPS/libglvnd" ] || { echo "once scripts/96-libglvnd.sh calistirin" >&2; exit 1; }

command -v qmake6 >/dev/null || { echo "host'ta qt6-base yok: sudo pacman -S qt6-base" >&2; exit 1; }
HOST_QT_VER="$(qmake6 -query QT_VERSION)"
[ "$HOST_QT_VER" = "$QTBASE_VER" ] || {
    echo "host qt6-base surumu ($HOST_QT_VER) QTBASE_VER ($QTBASE_VER) ile eslesmiyor - QT_HOST_PATH tool'lari (moc/rcc/uic) surum uyumsuzlugunda hedef build'i reddeder" >&2
    exit 1
}

[ -d "$BUILD/$QTBASE_SRC" ] || tar -xf "$SOURCES/$QTBASE_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$QTBASE_SRC"

TOOLCHAIN_FILE="$BUILD/qt-toolchain.cmake"
cat > "$TOOLCHAIN_FILE" <<EOF
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER $TARGET-gcc)
set(CMAKE_CXX_COMPILER $TARGET-g++)
set(CMAKE_SYSROOT $LFS)
set(CMAKE_FIND_ROOT_PATH $LFS)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOF

rm -rf build
mkdir -p build
cmake -S . -B build -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DQT_HOST_PATH=/usr \
    -DQT_FEATURE_xcb=ON \
    -DQT_FEATURE_dbus=ON \
    -DQT_FEATURE_sql=ON \
    -DQT_FEATURE_sql_sqlite=ON \
    -DQT_FEATURE_sql_psql=OFF \
    -DQT_FEATURE_sql_mysql=OFF \
    -DQT_FEATURE_sql_odbc=OFF \
    -DQT_FEATURE_testlib=ON \
    -DQT_BUILD_EXAMPLES=OFF \
    -DQT_BUILD_TESTS=OFF \
    -DQT_FEATURE_openssl_linked=ON \
    -DQT_FEATURE_zstd=ON \
    -DQT_FEATURE_opengl=ON \
    -DQT_FEATURE_egl=ON \
    -DQT_FEATURE_xcb_glx_plugin=ON \
    -DINPUT_opengl=desktop
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/qtbase"
echo "qtbase hazir"
