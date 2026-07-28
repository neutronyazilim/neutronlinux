#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

command -v grub-mkrescue >/dev/null || { echo "grub-mkrescue yok. sudo pacman -S grub xorriso mtools" >&2; exit 1; }
[ -f "$OUTPUT/bzImage" ] || { echo "$OUTPUT/bzImage yok, once scripts/04-kernel.sh calistirin" >&2; exit 1; }
[ -f "$OUTPUT/initramfs.cpio.gz" ] || { echo "$OUTPUT/initramfs.cpio.gz yok, once scripts/06-image.sh calistirin" >&2; exit 1; }

ISODIR="$BUILD/iso"
rm -rf "$ISODIR"
mkdir -p "$ISODIR/boot/grub"
cp "$OUTPUT/bzImage" "$ISODIR/boot/bzImage"
cp "$OUTPUT/initramfs.cpio.gz" "$ISODIR/boot/initramfs.cpio.gz"

EMBEDDED_ENTRY=""
if [ -f "$OUTPUT/bzImage-embedded" ]; then
    cp "$OUTPUT/bzImage-embedded" "$ISODIR/boot/bzImage-embedded"
    EMBEDDED_ENTRY='
menuentry "NeutronLinux (initramfs gomulu, initrd yok)" {
    linux /boot/bzImage-embedded console=tty0 console=ttyS0 earlyprintk=efi,keep nokaslr
}
menuentry "NeutronLinux (gomulu + acpi=off nomodeset)" {
    linux /boot/bzImage-embedded console=tty0 console=ttyS0 earlyprintk=efi,keep nokaslr efi=old_map acpi=off noapic nolapic nomodeset
}'
fi

cat > "$ISODIR/boot/grub/grub.cfg" <<EOF_MARKER
set timeout=5
set default=0
set gfxpayload=text

menuentry "NeutronLinux (default, ayri initrd)" {
    linux /boot/bzImage console=tty0 console=ttyS0 earlyprintk=efi,keep nokaslr
    initrd /boot/initramfs.cpio.gz
}
$EMBEDDED_ENTRY
EOF_MARKER

grub-mkrescue -o "$OUTPUT/neutronlinux.iso" "$ISODIR"

echo "ISO hazir: $OUTPUT/neutronlinux.iso"
ls -lh "$OUTPUT/neutronlinux.iso"
