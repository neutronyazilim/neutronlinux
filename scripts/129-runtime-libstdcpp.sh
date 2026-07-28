#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/runtime-libstdcpp" ] && { echo "runtime-libstdcpp zaten kurulmus, atlaniyor"; exit 0; }

TOOLLIB="$LFS/tools/x86_64-neutron-linux-gnu/lib64"
[ -d "$TOOLLIB" ] || { echo "$TOOLLIB yok - cross toolchain bulunamadi" >&2; exit 1; }

cp -a "$TOOLLIB"/libstdc++.so.6.0.32 "$LFS/usr/lib/"
cp -a "$TOOLLIB"/libstdc++.so.6 "$LFS/usr/lib/"
cp -a "$TOOLLIB"/libgcc_s.so.1 "$LFS/usr/lib/"
cp -a "$TOOLLIB"/libatomic.so.1.2.0 "$LFS/usr/lib/"
cp -a "$TOOLLIB"/libatomic.so.1 "$LFS/usr/lib/"
cp -a "$TOOLLIB"/libgomp.so.1.0.0 "$LFS/usr/lib/"
cp -a "$TOOLLIB"/libgomp.so.1 "$LFS/usr/lib/"
chmod 755 "$LFS/usr/lib/libstdc++.so.6.0.32" "$LFS/usr/lib/libgcc_s.so.1" \
    "$LFS/usr/lib/libatomic.so.1.2.0" "$LFS/usr/lib/libgomp.so.1.0.0"

ldconfig -r "$LFS"

"$LFS/usr/lib/ld-linux-x86-64.so.2" --library-path "$LFS/usr/lib" \
    "$LFS/usr/bin/localedef" -i C -f UTF-8 "$LFS/usr/lib/locale/C.UTF-8"

cat > "$LFS/root/.xinitrc" <<'EOF'
export XDG_RUNTIME_DIR=/run/user/$(id -u)
mkdir -p "$XDG_RUNTIME_DIR"
chmod 0700 "$XDG_RUNTIME_DIR"
export QT_PLUGIN_PATH=/usr/plugins:/usr/lib/qt6/plugins
export QML2_IMPORT_PATH=/usr/qml:/usr/lib/qt6/qml
export QML_IMPORT_PATH=/usr/qml:/usr/lib/qt6/qml
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
exec dbus-run-session startplasma-x11 > /var/log/startplasma.log 2>&1
EOF
chmod +x "$LFS/root/.xinitrc"

touch "$STAMPS/runtime-libstdcpp"
echo "runtime-libstdcpp hazir"
