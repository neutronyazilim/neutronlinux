#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/plasma-env" ] && { echo "plasma-workspace env zaten var, atlaniyor"; exit 0; }

mkdir -p "$LFS/etc/xdg/plasma-workspace/env"
cat > "$LFS/etc/xdg/plasma-workspace/env/qt-plugin-paths.sh" <<'EOF'
export QT_PLUGIN_PATH="/usr/plugins:/usr/lib/qt6/plugins${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
export QML2_IMPORT_PATH="/usr/lib/qt6/qml${QML2_IMPORT_PATH:+:$QML2_IMPORT_PATH}"
export QML_IMPORT_PATH="/usr/lib/qt6/qml${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}"
EOF
chmod +x "$LFS/etc/xdg/plasma-workspace/env/qt-plugin-paths.sh"

if ! grep -q QT_PLUGIN_PATH "$LFS/etc/environment" 2>/dev/null; then
    cat >> "$LFS/etc/environment" <<'EOF'
QT_PLUGIN_PATH=/usr/plugins:/usr/lib/qt6/plugins
QML2_IMPORT_PATH=/usr/lib/qt6/qml
QML_IMPORT_PATH=/usr/lib/qt6/qml
EOF
fi

touch "$STAMPS/plasma-env"
echo "plasma-workspace env dosyasi olusturuldu"
