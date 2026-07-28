#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

[ -f "$OUTPUT/neutronlinux.img" ] || { echo "$OUTPUT/neutronlinux.img yok" >&2; exit 1; }

for cmd in mkisofs isohybrid; do
    command -v "$cmd" >/dev/null || { echo "$cmd yok. sudo pacman -S cdrtools libisoburn" >&2; exit 1; }
done

WORKDIR="$BUILD/simple-live-iso"
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR/iso-root/boot"

cp "$OUTPUT/bzImage" "$WORKDIR/iso-root/boot/vmlinuz"
cp "$BUILD/disk-image/mini-initramfs.cpio.gz" "$WORKDIR/iso-root/boot/initrd.img"

mkdir -p "$WORKDIR/iso-root/boot/grub"
cat > "$WORKDIR/iso-root/boot/grub/grub.cfg" <<'EOF'
set timeout=5
set default=0
menuentry "NeutronLinux Live (Disk Image)" {
    linux /boot/vmlinuz root=/dev/vda3 ro console=tty0 earlyprintk=efi,keep nokaslr
    initrd /boot/initrd.img
}
EOF

mkdir -p "$WORKDIR/iso-root/EFI/BOOT"
grub-mkstandalone -O x86_64-efi -o "$WORKDIR/iso-root/EFI/BOOT/BOOTX64.EFI" \
    "boot/grub/grub.cfg=$WORKDIR/iso-root/boot/grub/grub.cfg"

cp "$OUTPUT/neutronlinux.img" "$WORKDIR/iso-root/disk.img"

ISO="$OUTPUT/neutronlinux-live.iso"
mkisofs -R -J -V "NeutronLinux Live" -b isolinux/isolinux.bin -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot -e EFI/BOOT/BOOTX64.EFI -no-emul-boot \
    -o "$ISO" "$WORKDIR/iso-root" 2>&1 || true

isohybrid --uefi "$ISO" 2>&1 || true

echo "Live ISO hazir: $ISO"
ls -lh "$ISO"
