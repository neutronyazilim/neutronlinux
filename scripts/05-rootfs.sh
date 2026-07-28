#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

[ -x "$LFS/bin/busybox" ] || [ -x "$LFS/usr/bin/busybox" ] || \
    { echo "busybox bulunamadi, once scripts/03-busybox.sh calistirin" >&2; exit 1; }

mkdir -p "$LFS"/{dev,proc,sys,etc,tmp,root,etc/init.d,usr/bin}

for l in lib lib64; do
    [ -L "$LFS/$l" ] || rm -rf "$LFS/$l"
    ln -sfn usr/lib "$LFS/$l"
done

[ -x "$LFS/bin/busybox" ] && [ ! -L "$LFS/bin" ] && mv -f "$LFS/bin/busybox" "$LFS/usr/bin/busybox"
if [ -d "$LFS/usr/sbin" ] && [ ! -L "$LFS/usr/sbin" ]; then
    for f in "$LFS/usr/sbin"/*; do
        [ -e "$f" ] || continue
        name=$(basename "$f")
        [ -e "$LFS/usr/bin/$name" ] || mv "$f" "$LFS/usr/bin/$name"
    done
fi
for applet in $("$LFS/usr/bin/busybox" --list); do
    target="$LFS/usr/bin/$applet"
    if [ -e "$target" ] && [ "$(readlink "$target" 2>/dev/null)" != "/usr/bin/busybox" ]; then
        continue
    fi
    ln -sfn /usr/bin/busybox "$target"
done
rm -rf "$LFS/bin" "$LFS/sbin" "$LFS/usr/sbin"
ln -sfn usr/bin "$LFS/bin"
ln -sfn usr/bin "$LFS/sbin"
ln -sfn bin "$LFS/usr/sbin"

cat > "$LFS/etc/os-release" <<EOF
NAME="NeutronLinux"
VERSION="0.1 (Atom)"
VERSION_CODENAME=atom
ID=neutronlinux
PRETTY_NAME="NeutronLinux 0.1 (Atom)"
LOGO=distributor-logo-neutronlinux
EOF
echo neutronlinux > "$LFS/etc/hostname"
echo "Welcome to NeutronLinux" > "$LFS/etc/issue"

ROOT_SHELL=/bin/sh
[ -x "$LFS/usr/bin/bash" ] && ROOT_SHELL=/usr/bin/bash

cat > "$LFS/etc/passwd" <<EOF
root:x:0:0:root:/root:$ROOT_SHELL
messagebus:x:18:18:D-Bus system message bus:/run/dbus:/usr/bin/nologin
EOF
cat > "$LFS/etc/group" <<'EOF'
root:x:0:
messagebus:x:18:
EOF
ROOT_HASH="$(openssl passwd -6 root)"
cat > "$LFS/etc/shadow" <<EOF
root:$ROOT_HASH:19000:0:99999:7:::
EOF
chmod 600 "$LFS/etc/shadow"

cat > "$LFS/etc/inittab" <<'EOF'
::sysinit:/etc/init.d/rcS
ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100
tty1::respawn:/sbin/getty 38400 tty1
::ctrlaltdel:/sbin/reboot
::shutdown:/bin/umount -a -r
::restart:/sbin/init
EOF

cat > "$LFS/etc/init.d/rcS" <<'EOF'
hostname -F /etc/hostname
echo
echo "NeutronLinux - $(uname -a)"
echo
EOF
chmod +x "$LFS/etc/init.d/rcS"

cat > "$LFS/init" <<'EOF'
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev 2>/dev/null

exec /sbin/init
EOF
chmod +x "$LFS/init"

echo "rootfs hazir: $LFS"
