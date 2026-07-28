#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

for cmd in parted mformat mcopy mmd grub-mkstandalone grub-mkimage grub-bios-setup mke2fs; do
    command -v "$cmd" >/dev/null || { echo "$cmd yok. sudo pacman -S parted mtools grub e2fsprogs" >&2; exit 1; }
done
[ -x "$LFS/usr/lib/systemd/systemd" ] || { echo "sysroot eksik, once 22-systemd-rootfs.sh'a kadar calistirin" >&2; exit 1; }
[ -f "$OUTPUT/bzImage" ] || { echo "$OUTPUT/bzImage yok, once scripts/04-kernel.sh calistirin" >&2; exit 1; }

IMG="$OUTPUT/neutronlinux.img"
WORKDIR="$BUILD/disk-image"
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

MINI="$WORKDIR/mini-initramfs"
mkdir -p "$MINI/bin" "$MINI"/{dev,proc,sys,newroot}
cp "$LFS/usr/bin/busybox" "$MINI/bin/busybox"
for applet in $("$LFS/usr/bin/busybox" --list); do
    ln -sf busybox "$MINI/bin/$applet"
done
cat > "$MINI/init" <<'EOF'
export PATH=/bin
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev 2>/dev/null

try_installed_root() {
    ROOTDEV="$(findfs LABEL=NEUTRONROOT 2>/dev/null)"
    [ -n "$ROOTDEV" ] || return 1
    mount -t ext4 "$ROOTDEV" /newroot 2>/dev/null || return 1
    return 0
}

setup_live_from_dir() {
    src="$1"
    [ -f "$src/live/root.squashfs" ] || return 1
    mkdir -p /squashfs /overlay /newroot
    mount -o ro,loop "$src/live/root.squashfs" /squashfs 2>/dev/null || return 1
    mount -t tmpfs tmpfs /overlay
    mkdir -p /overlay/upper /overlay/work
    mount -t overlay overlay -o lowerdir=/squashfs,upperdir=/overlay/upper,workdir=/overlay/work /newroot 2>/dev/null || {
        umount /squashfs 2>/dev/null; umount /overlay 2>/dev/null; return 1
    }
    return 0
}

try_live_root() {
    for devpath in /sys/block/*/dev; do
        [ -e "$devpath" ] || continue
        base="$(basename "$(dirname "$devpath")")"
        sz="$(cat "/sys/block/$base/size" 2>/dev/null)"
        [ -n "$sz" ] && [ "$sz" -gt 0 ] 2>/dev/null || continue
        for candidate in "/dev/$base" "/dev/${base}1" "/dev/${base}2" "/dev/${base}p1" "/dev/${base}p2"; do
            [ -b "$candidate" ] || continue
            mkdir -p /cdrom
            mount -o ro "$candidate" /cdrom 2>/dev/null || continue
            if setup_live_from_dir /cdrom; then
                return 0
            fi
            for iso in /cdrom/neutronlinux*.iso /cdrom/*/neutronlinux*.iso; do
                [ -f "$iso" ] || continue
                mkdir -p /isomnt
                mount -o ro,loop "$iso" /isomnt 2>/dev/null || continue
                if setup_live_from_dir /isomnt; then
                    return 0
                fi
                umount /isomnt 2>/dev/null
            done
            umount /cdrom 2>/dev/null
        done
    done
    return 1
}

i=0
FOUND=0
while [ "$FOUND" -eq 0 ]; do
    if try_installed_root; then FOUND=1; break; fi
    if try_live_root; then FOUND=1; break; fi
    i=$((i + 1))
    if [ "$i" -ge 60 ]; then
        echo "Ne NEUTRONROOT ne de live squashfs bulunamadi, deneme devam ediyor" >/dev/console 2>/dev/null
        i=0
    fi
    sleep 1
done

mount --move /proc /newroot/proc
mount --move /sys /newroot/sys
mount --move /dev /newroot/dev

for mp in /cdrom /isomnt; do
    if mountpoint -q "$mp" 2>/dev/null; then
        mkdir -p "/newroot$mp"
        mount --move "$mp" "/newroot$mp" 2>/dev/null
    fi
done

exec switch_root /newroot /usr/lib/systemd/systemd
EOF
chmod +x "$MINI/init"

GEN_INIT_CPIO="$BUILD/$LINUX_SRC/usr/gen_init_cpio"
DEV_SPEC="$WORKDIR/dev-nodes.list"
cat > "$DEV_SPEC" <<'EOF'
dir /dev 0755 0 0
nod /dev/console 0600 0 0 c 5 1
nod /dev/null 0666 0 0 c 1 3
nod /dev/tty 0666 0 0 c 5 0
EOF
(
    cd "$MINI"
    { [ -x "$GEN_INIT_CPIO" ] && "$GEN_INIT_CPIO" "$DEV_SPEC"
      find . ! -path ./dev | cpio -o -H newc -R 0:0 2>/dev/null
    } | gzip -9
) > "$WORKDIR/mini-initramfs.cpio.gz"

ESP_SIZE_MIB=256
IMG_SIZE_MIB=8192
BIOSBOOT_SIZE_MIB=1
rm -f "$IMG"
truncate -s "${IMG_SIZE_MIB}M" "$IMG"

parted -s "$IMG" mklabel gpt
parted -s "$IMG" mkpart BIOSBOOT 1MiB "$((BIOSBOOT_SIZE_MIB + 1))MiB"
parted -s "$IMG" set 1 bios_grub on
parted -s "$IMG" mkpart ESP fat32 "$((BIOSBOOT_SIZE_MIB + 1))MiB" "$((BIOSBOOT_SIZE_MIB + ESP_SIZE_MIB + 1))MiB"
parted -s "$IMG" set 2 esp on
parted -s "$IMG" mkpart ROOT ext4 "$((BIOSBOOT_SIZE_MIB + ESP_SIZE_MIB + 1))MiB" 100%

BIOSBOOT_OFFSET_BYTES=$((1024 * 1024))
ESP_OFFSET_BYTES=$(((BIOSBOOT_SIZE_MIB + 1) * 1024 * 1024))
ROOT_OFFSET_BYTES=$(((BIOSBOOT_SIZE_MIB + ESP_SIZE_MIB + 1) * 1024 * 1024))
ROOT_SIZE_BYTES=$(((IMG_SIZE_MIB * 1024 * 1024) - ROOT_OFFSET_BYTES - (8 * 1024 * 1024)))

export MTOOLS_SKIP_CHECK=1
mformat -i "$IMG@@${ESP_OFFSET_BYTES}" -v NEUTRONESP -F ::
M="mcopy -i $IMG@@${ESP_OFFSET_BYTES}"
MD="mmd -i $IMG@@${ESP_OFFSET_BYTES}"
$MD ::EFI
$MD ::EFI/BOOT
$MD ::boot

cat > "$WORKDIR/grub.cfg" <<'EOF'
insmod part_gpt
insmod fat
search --no-floppy --set=root --file /boot/bzImage
set timeout=5
set default=0
set gfxpayload=text

menuentry "NeutronLinux" {
    linux /boot/bzImage console=tty0 console=ttyS0 earlyprintk=efi,keep nokaslr
    initrd /boot/initramfs.cpio.gz
}
EOF
GRUB_EFI_PREFIX="$(nix build nixpkgs#grub2_efi --no-link --print-out-paths)"
grub-mkstandalone -O x86_64-efi --directory="$GRUB_EFI_PREFIX/lib/grub/x86_64-efi" \
    -o "$WORKDIR/BOOTX64.EFI" \
    "boot/grub/grub.cfg=$WORKDIR/grub.cfg"

$M "$WORKDIR/BOOTX64.EFI" ::EFI/BOOT/BOOTX64.EFI
$M "$OUTPUT/bzImage" ::boot/bzImage
$M "$WORKDIR/mini-initramfs.cpio.gz" ::boot/initramfs.cpio.gz
$MD ::boot/grub
$M "$WORKDIR/grub.cfg" ::boot/grub/grub.cfg

GRUBDIR="$WORKDIR/grub-i386-pc"
mkdir -p "$GRUBDIR"
GRUB_PC_PREFIX="$(dirname "$(dirname "$(readlink -f "$(command -v grub-mkstandalone)")")")"
cp "$GRUB_PC_PREFIX/lib/grub/i386-pc/boot.img" "$GRUBDIR/"
cat > "$WORKDIR/embedded.cfg" <<'EOF'
search --no-floppy --set=root --file /boot/grub/grub.cfg
configfile /boot/grub/grub.cfg
EOF
grub-mkimage -O i386-pc -o "$GRUBDIR/core.img" -p '/boot/grub' \
    -c "$WORKDIR/embedded.cfg" \
    part_gpt fat biosdisk normal configfile search search_fs_uuid search_fs_file search_label echo ls linux
echo "(hd0) $IMG" > "$WORKDIR/device.map"
sudo grub-bios-setup -d "$GRUBDIR" -m "$WORKDIR/device.map" "$IMG"

trap '[ -d "$BUILD/.tools-aside" ] && mv "$BUILD/.tools-aside" "$LFS/tools"' EXIT
if [ -d "$LFS/tools" ]; then
    mv "$LFS/tools" "$BUILD/.tools-aside"
fi

ROOT_IMG="$WORKDIR/root.ext4"
rm -f "$ROOT_IMG"
sudo mke2fs -q -t ext4 -L NEUTRONROOT -d "$LFS" "$ROOT_IMG" "$((ROOT_SIZE_BYTES / 1024))K"
sudo chown "$(id -u):$(id -g)" "$ROOT_IMG"

mv "$BUILD/.tools-aside" "$LFS/tools"
trap - EXIT

dd if="$ROOT_IMG" of="$IMG" bs=1M seek=$((ROOT_OFFSET_BYTES / 1024 / 1024)) conv=notrunc status=none

echo "Disk imaji hazir: $IMG"
ls -lh "$IMG"
echo "USB'ye yazmak icin: sudo dd if=$IMG of=/dev/sdX bs=4M status=progress"
