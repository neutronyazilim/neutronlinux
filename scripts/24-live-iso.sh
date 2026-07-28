#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

[ -f "$OUTPUT/neutronlinux.img" ] || { echo "$OUTPUT/neutronlinux.img yok, once scripts/23-disk-image.sh calistirin" >&2; exit 1; }

for cmd in mksquashfs grub-mkrescue; do
    command -v "$cmd" >/dev/null || { echo "$cmd yok. sudo pacman -S squashfs-tools grub libisoburn" >&2; exit 1; }
done

WORKDIR="$BUILD/live-iso"
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

echo "Live ISO yapılıyor..."

LOOP=$(sudo losetup -f)
sudo losetup -P "$LOOP" "$OUTPUT/neutronlinux.img"
ROOTFS_MOUNT="$WORKDIR/rootfs-mount"
mkdir -p "$ROOTFS_MOUNT"
sudo mount -o ro "${LOOP}p3" "$ROOTFS_MOUNT" || { echo "Mount failed!"; exit 1; }

SQUASHFS="$WORKDIR/root.squashfs"
echo "Rootfs squashfs'e compressing..."
sudo mksquashfs "$ROOTFS_MOUNT" "$SQUASHFS" -comp xz -Xdict-size 100% 2>&1 | tail -30
sudo chown "$(id -u):$(id -g)" "$SQUASHFS"

ISO_ROOT="$WORKDIR/iso-root"
mkdir -p "$ISO_ROOT"/{boot/grub,live}

cp "$OUTPUT/bzImage" "$ISO_ROOT/boot/vmlinuz"
cp "$WORKDIR/../disk-image/mini-initramfs.cpio.gz" "$ISO_ROOT/boot/initrd.img"
sudo cp "$SQUASHFS" "$ISO_ROOT/live/root.squashfs"

cat > "$ISO_ROOT/boot/grub/grub.cfg" <<'EOF'
set timeout=5
set default=0

menuentry "NeutronLinux Live" {
    linux /boot/vmlinuz console=tty0 console=ttyS0
    initrd /boot/initrd.img
}
EOF

command -v grub-mkrescue >/dev/null || { echo "grub-mkrescue yok. sudo pacman -S grub" >&2; exit 1; }
ISO="$OUTPUT/neutronlinux-live.iso"
echo "ISO oluşturuluyor (grub-mkrescue)..."
grub-mkrescue -o "$ISO" "$ISO_ROOT" 2>&1 | tail -20

sudo umount "$ROOTFS_MOUNT" 2>/dev/null || sudo umount -l "$ROOTFS_MOUNT" 2>/dev/null || true
sudo losetup -d "$LOOP" 2>/dev/null || true
sudo rm -rf "$WORKDIR/rootfs-mount" 2>/dev/null || true

echo "Live ISO hazir: $ISO"
ls -lh "$ISO"
echo "USB'ye yazmak icin: sudo dd if=$ISO of=/dev/sdX bs=4M status=progress"
