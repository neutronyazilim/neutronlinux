#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

[ -d "$LFS/usr/bin" ] || { echo "sysroot eksik, once 05-rootfs.sh calistirin" >&2; exit 1; }

mkdir -p "$LFS/usr/bin" "$LFS/etc"

cat > "$LFS/etc/npkg.conf" <<'EOF'
REPO_URL=http://10.0.2.2:8000
EOF

cat > "$LFS/usr/bin/npkg" <<'NPKG_EOF'
set -e

DB=/var/lib/npkg
CONF=/etc/npkg.conf
[ -f "$CONF" ] && . "$CONF"
REPO_URL="${REPO_URL:-http://10.0.2.2:8000}"

mkdir -p "$DB/installed"

usage() {
    echo "Kullanim: npkg install|remove|list|search|info <isim>"
    exit 1
}

index_line() {
    wget -qO- "$REPO_URL/index.csv" | grep "^$1," | tail -n1
}

cmd_install() {
    name="$1"
    [ -n "$name" ] || usage
    line="$(index_line "$name")"
    [ -n "$line" ] || { echo "npkg: '$name' repo'da bulunamadi" >&2; exit 1; }
    version="$(echo "$line" | cut -d, -f2)"
    file="$(echo "$line" | cut -d, -f3)"

    if [ -f "$DB/installed/$name.version" ]; then
        echo "npkg: '$name' zaten kurulu ($(cat "$DB/installed/$name.version")), yeniden kuruluyor"
    fi

    tmp="/tmp/npkg-$name.tar.xz"
    echo "indiriliyor: $REPO_URL/$file"
    wget -qO "$tmp" "$REPO_URL/$file"

    tar -tJf "$tmp" > "$DB/installed/$name.files"
    tar -xJf "$tmp" -C /
    echo "$version" > "$DB/installed/$name.version"
    rm -f "$tmp"
    echo "kuruldu: $name $version"
}

cmd_remove() {
    name="$1"
    [ -n "$name" ] || usage
    [ -f "$DB/installed/$name.files" ] || { echo "npkg: '$name' kurulu degil" >&2; exit 1; }

    tac "$DB/installed/$name.files" | while read -r entry; do
        path="/$entry"
        case "$entry" in
            */) rmdir "$path" 2>/dev/null || true ;;
            *) rm -f "$path" ;;
        esac
    done

    rm -f "$DB/installed/$name.files" "$DB/installed/$name.version"
    echo "kaldirildi: $name"
}

cmd_list() {
    for f in "$DB"/installed/*.version; do
        [ -e "$f" ] || continue
        name="$(basename "$f" .version)"
        echo "$name $(cat "$f")"
    done
}

cmd_search() {
    wget -qO- "$REPO_URL/index.csv" | { [ -n "${1:-}" ] && grep -i "$1" || cat; }
}

cmd_info() {
    name="$1"
    [ -n "$name" ] || usage
    if [ -f "$DB/installed/$name.version" ]; then
        echo "kurulu: $name $(cat "$DB/installed/$name.version")"
        echo "dosyalar:"
        cat "$DB/installed/$name.files"
    else
        echo "kurulu degil: $name"
        line="$(index_line "$name")"
        [ -n "$line" ] && echo "repo'da mevcut: $(echo "$line" | cut -d, -f2)"
    fi
}

case "${1:-}" in
    install) shift; cmd_install "$@" ;;
    remove)  shift; cmd_remove "$@" ;;
    list)    cmd_list ;;
    search)  shift; cmd_search "$@" ;;
    info)    shift; cmd_info "$@" ;;
    *) usage ;;
esac
NPKG_EOF
chmod +x "$LFS/usr/bin/npkg"

echo "npkg hazir: $LFS/usr/bin/npkg"
