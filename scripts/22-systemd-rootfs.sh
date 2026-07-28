#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

[ -x "$LFS/usr/lib/systemd/systemd" ] || { echo "systemd yok, once scripts/21-systemd.sh calistirin" >&2; exit 1; }
[ -f "$LFS/etc/passwd" ] || { echo "$LFS/etc/passwd yok, once scripts/05-rootfs.sh calistirin" >&2; exit 1; }

STAMPS="$BUILD/.stamps"
if [ ! -f "$STAMPS/dbus-systemd" ]; then
    ( cd "$BUILD/$DBUS_SRC"
      BUILD_TRIPLET="$(sh ./config.guess 2>/dev/null || sh ./build-aux/config.guess)"
      ./configure \
          --host="$TARGET" --build="$BUILD_TRIPLET" --prefix=/usr --sysconfdir=/etc \
          --localstatedir=/var \
          CC="$TARGET-gcc" \
          --disable-static --disable-tests --disable-embedded-tests \
          --disable-doxygen-docs --disable-xml-docs \
          --disable-selinux --disable-apparmor --disable-libaudit --enable-systemd \
          --with-session-socket-dir=/tmp
      make
      make DESTDIR="$LFS" install )
    touch "$STAMPS/dbus-systemd"
    echo "dbus (systemd destekli) yeniden derlendi"
fi

: > "$LFS/etc/machine-id"
mkdir -p "$LFS/etc/systemd/system"
ln -sfn /usr/lib/systemd/system/multi-user.target "$LFS/etc/systemd/system/default.target"

cat > "$LFS/etc/systemd/system.conf" <<'EOF'
[Manager]
DefaultDeviceTimeoutSec=20
EOF

mkdir -p "$LFS/etc/systemd/system/getty.target.wants"
ln -sfn /usr/lib/systemd/system/getty@.service \
    "$LFS/etc/systemd/system/getty.target.wants/getty@tty1.service"

mkdir -p "$LFS/etc/pam.d"
cat > "$LFS/etc/pam.d/login" <<'EOF'
auth     required  pam_unix.so
account  required  pam_unix.so
password required  pam_unix.so
session  required  pam_unix.so
session  optional  pam_systemd.so
EOF
cat > "$LFS/etc/pam.d/other" <<'EOF'
auth     required  pam_deny.so
account  required  pam_deny.so
password required  pam_deny.so
session  required  pam_deny.so
EOF
cp "$LFS/etc/pam.d/login" "$LFS/etc/pam.d/su"

mkdir -p "$LFS/usr/lib/systemd/system" "$LFS/usr/lib/tmpfiles.d"
cat > "$LFS/usr/lib/systemd/system/dbus.socket" <<'EOF'
[Unit]
Description=D-Bus System Message Bus Socket

[Socket]
ListenStream=/run/dbus/system_bus_socket

[Install]
WantedBy=sockets.target
EOF
cat > "$LFS/usr/lib/systemd/system/dbus.service" <<'EOF'
[Unit]
Description=D-Bus System Message Bus
Requires=dbus.socket

[Service]
ExecStart=/usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
ExecReload=/usr/bin/dbus-send --print-reply --system --type=method_call --dest=org.freedesktop.DBus / org.freedesktop.DBus.ReloadConfig
OOMScoreAdjust=-900

[Install]
WantedBy=multi-user.target
Alias=dbus.service
EOF
cat > "$LFS/usr/lib/tmpfiles.d/dbus.conf" <<'EOF'
d /run/dbus 0755 root root -
EOF
mkdir -p "$LFS/etc/systemd/system/sockets.target.wants" "$LFS/etc/systemd/system/multi-user.target.wants"
ln -sfn /usr/lib/systemd/system/dbus.socket \
    "$LFS/etc/systemd/system/sockets.target.wants/dbus.socket"
ln -sfn /usr/lib/systemd/system/dbus.service \
    "$LFS/etc/systemd/system/multi-user.target.wants/dbus.service"

cat > "$LFS/etc/login.defs" <<'EOF'
LOGIN_TIMEOUT           300
EOF

rm -f "$LFS/etc/systemd/system/systemd-logind.service" \
      "$LFS/etc/systemd/system/systemd-logind-varlink.socket"

cat > "$LFS/init" <<'EOF'
export PATH=/usr/bin:/usr/sbin:/bin:/sbin

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev 2>/dev/null

mkdir -p /newroot
mount -t tmpfs -o mode=0755 tmpfs /newroot

for d in /*; do
    case "$d" in
        /proc|/sys|/dev|/newroot) continue ;;
    esac
    cp -a "$d" /newroot/ 2>/dev/null
done

mkdir -p /newroot/proc /newroot/sys /newroot/dev
mount --move /proc /newroot/proc
mount --move /sys /newroot/sys
mount --move /dev /newroot/dev

exec switch_root /newroot /usr/lib/systemd/systemd
EOF
chmod +x "$LFS/init"

mkdir -p "$LFS/etc/systemd/network"
cat > "$LFS/etc/systemd/network/20-wired.network" <<'EOF'
[Match]
Name=en* eth*

[Network]
DHCP=yes
EOF
mkdir -p "$LFS/etc/systemd/system/multi-user.target.wants"
ln -sfn /usr/lib/systemd/system/systemd-networkd.service \
    "$LFS/etc/systemd/system/multi-user.target.wants/systemd-networkd.service"
ln -sfn /usr/lib/systemd/system/systemd-resolved.service \
    "$LFS/etc/systemd/system/multi-user.target.wants/systemd-resolved.service"
ln -sfn /run/systemd/resolve/stub-resolv.conf "$LFS/etc/resolv.conf"

cat > "$LFS/etc/nsswitch.conf" <<'EOF'
passwd:    files
group:     files
shadow:    files
hosts:     files dns
networks:  files
EOF

cat > "$LFS/usr/bin/netcheck" <<'EOF'
echo "== arayuzler =="
ip addr
echo
echo "== DNS (nslookup) =="
nslookup neutronlinux.local 1.1.1.1 >/dev/null 2>&1
nslookup example.com || echo "DNS cozumleme basarisiz"
echo
echo "== ping 1.1.1.1 (DNS'siz baglanti) =="
ping -c 3 1.1.1.1 || echo "ping basarisiz"
echo
echo "== wget http://example.com (tam yigin: DNS + HTTP) =="
wget -q -O- http://example.com | head -c 200 || echo "wget basarisiz"
echo
EOF
chmod +x "$LFS/usr/bin/netcheck"

find "$LFS" -perm -4000 -o -perm -2000 2>/dev/null | while read -r f; do
    chmod u-s,g-s "$f"
done

echo "systemd rootfs entegrasyonu hazir"
