#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/zsh" ] && { echo "zsh zaten derlenmis, atlaniyor"; exit 0; }
[ -f "$STAMPS/ncurses" ] || { echo "once ncurses icin ilgili scripti calistirin" >&2; exit 1; }

[ -d "$BUILD/$ZSH_SRC" ] || tar -xf "$SOURCES/$ZSH_SRC.tar.xz" -C "$BUILD"
cd "$BUILD/$ZSH_SRC"

BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./Util/config.guess)"
./configure \
    --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr \
    CC="$TARGET-gcc" \
    --enable-multibyte --with-term-lib="ncursesw" \
    --disable-gdbm \
    zsh_cv_shared_environ=yes \
    zsh_cv_sys_dynamic_clash_ok=yes \
    zsh_cv_sys_dynamic_rtld_global=no \
    zsh_cv_path_dev_fd=yes

make
make DESTDIR="$LFS" install

sed -i 's|^root:x:0:0:root:/root:.*|root:x:0:0:root:/root:/usr/bin/zsh|' "$LFS/etc/passwd"
grep -q "^/usr/bin/zsh$" "$LFS/etc/shells" 2>/dev/null || echo "/usr/bin/zsh" >> "$LFS/etc/shells"
cat > "$LFS/root/.zshrc" <<'EOF'
autoload -Uz compinit && compinit
PROMPT='%~ %# '
EOF

touch "$STAMPS/zsh"
echo "zsh hazir"
