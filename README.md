# NeutronLinux

Sıfırdan (LFS yöntemiyle) derlenmiş, `x86_64-neutron-linux-gnu` hedefine
sahip bağımsız bir Linux dağıtımı: kendi cross toolchain'i, kendi kernel
config'i, kendi init sistemi (systemd) ve tam bir **KDE Plasma 6**
masaüstü — hiçbir paket başka bir dağıtımdan miras alınmadan, tek tek
kaynak koddan derlenerek inşa edildi.

## Özellikler

- **Cross-compiled from scratch**: binutils/gcc/glibc/kernel dahil tüm
  toolchain ve ~180 script'lik bağımlılık zinciriyle derlenen tam bir
  userland (BusyBox + GNU coreutils/sed/grep/gawk/findutils/...).
- **systemd** PID 1, `systemd-networkd`/`systemd-resolved` ile ağ,
  `systemd-udevd`, PAM tabanlı login.
- **KDE Plasma 6** masaüstü: `kwin`, `plasma-workspace`, `plasma-desktop`,
  `dolphin`, `konsole`, `systemsettings`, `sddm` (otomatik login),
  `kscreenlocker`, Breeze teması — Qt6 + KF6 yığınının tamamı sıfırdan
  derlendi.
- **Mesa/DRM donanım hızlandırması**: Intel (`i915`, Sandy Bridge HD
  Graphics dahil test edildi), AMD (`amdgpu`, GCN 1. nesilden itibaren),
  Nvidia (açık kaynak `nouveau`) — hiçbiri yoksa `llvmpipe` yazılımsal
  fallback.
- **Firefox** önceden derlenmiş olarak dahil.
- **[quark](../quark)** — kendi native paket yöneticimiz: `.qpk` formatı +
  Arch/Debian repolarından doğrudan kurulum + `:export`/`:import` ile tüm
  sistemi (paket listesi + dotfiles) tek bir `.qprof` dosyasına klonlama.
- **Calamares** grafik kurulum aracı ile canlı ortamdan diske kurulum.
- **İki ayrı boot imajı**: BIOS/legacy için hibrit ISO, UEFI/gerçek donanım
  için GPT+ext4 disk imajı — ikisi de `grub-mkrescue`/GRUB ile üretiliyor.
- Hem QEMU'da hem gerçek donanımda (Sandy Bridge ve Alder Lake nesli
  test edilen iki farklı fiziksel makine) uçtan uca doğrulandı.

## Sistem gereksinimleri

| | |
|---|---|
| CPU | x86_64, generic baseline (özel `-march` yok — pratikte 2006 sonrası her Intel/AMD işlemci) |
| RAM | 2GB minimum (CLI), 4GB+ önerilir (Plasma + Firefox) |
| Disk | 8GB+ (imaj boyutu), 20GB+ rahat kullanım için |
| GPU | Intel (`i915`), AMD (`amdgpu`, GCN1+), Nvidia (`nouveau`) — yoksa yazılımsal `llvmpipe` |
| Ağ | Ethernet (`e1000`/`e1000e`/`r8169`/`forcedeth`/`virtio-net`) + USB tethering (CDC-ECM/NCM/RNDIS/iPhone) |
| WiFi | **desteklenmiyor** (kernel'de hiçbir WiFi sürücüsü derlenmedi) |
| Boot | BIOS (legacy) ve UEFI, ikisi de |
| Dosya sistemi | ext4, vfat, exfat |

## Build

```sh
./scripts/00-prepare-host.sh    # host bağımlılık kontrolü
./scripts/01-fetch-sources.sh   # kaynak tarball'ları indir
./scripts/02-cross-toolchain.sh # x86_64-neutron-linux-gnu cross toolchain (en uzun adım)
```

Sonrasında `scripts/` altındaki script'ler numara sırasına göre
çalıştırılır — her biri kendi build aşamasını temsil eder ve
idempotent'tir (zaten tamamlanmış bir adımı atlar):

| Aralık | Kapsam |
|---|---|
| `00`–`09` | Host hazırlığı, cross toolchain, BusyBox, kernel, ilk rootfs |
| `10`–`36` | GNU coreutils/sed/grep/gawk/findutils/tar/... (BusyBox applet'lerinin yerini alan gerçek GNU araçları) |
| `19`–`23` | D-Bus, systemd, systemd tabanlı rootfs, disk imajı |
| `24` | Canlı ISO (squashfs + GRUB) |
| `40`–`42` | `quark`'ın native repo altyapısı, fastfetch |
| `43`–`58` | Minimal X11 yığını (xorg-server, dwm/st - Plasma'dan önceki ilk GUI adımı) |
| `59`–`165` | Qt6 + KF6 + Mesa + Wayland protokolleri + tüm Plasma 6 bileşenleri, Calamares, SDDM, Firefox öncesi bağımlılıklar |

Her script `config.sh`'taki sürüm pinlerini ve yolları kullanır. Cross
toolchain adımı donanıma göre 10-60+ dakika sürebilir.

## Boot etmek / QEMU'da test

```sh
qemu-system-x86_64 -enable-kvm -m 4G -smp 2 \
  -cdrom output/neutronlinux-live.iso -boot d \
  -netdev user,id=net0 -device e1000,netdev=net0 \
  -vnc :1
```

UEFI ile gerçek donanım hedefli disk imajını test etmek için:

```sh
cp /usr/share/edk2/x64/OVMF_VARS.4m.fd /tmp/OVMF_VARS.fd
qemu-system-x86_64 -enable-kvm -cpu host \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,file=/tmp/OVMF_VARS.fd \
  -drive if=none,format=raw,file=output/neutronlinux.img,id=disk \
  -device virtio-blk-pci,drive=disk -m 4G
```

USB'ye yazmak için:

```sh
sudo dd if=output/neutronlinux-live.iso of=/dev/sdX bs=4M status=progress   # BIOS/legacy
sudo dd if=output/neutronlinux.img of=/dev/sdX bs=4M status=progress       # UEFI (önerilen)
```

## Neden iki ayrı imaj?

GRUB'un El Torito (CD-ROM) ve FAT32 okuması dosya boyutuyla kötü
ölçekleniyor — büyüyen bir initramfs/kernel için tek başına CD-ROM/FAT32
üzerinden boot dakikalar sürebiliyor. Bunun yerine:

- **`neutronlinux-live.iso`**: küçük bir initramfs + squashfs sıkıştırmalı
  rootfs, GRUB sadece küçük dosyaları okuyor.
- **`neutronlinux.img`**: GPT, iki bölüm — küçük FAT32 ESP (GRUB + kernel
  + küçük initramfs) + sistemin tamamının bulunduğu bir **ext4** partition.
  GRUB sadece ESP'yi okuyor, kernelin kendi (hızlı) ext4 sürücüsü geri
  kalanını hallediyor.

## Proje yapısı

```
config.sh    sürüm pinleri, yollar, hedef triplet
scripts/     numaralı, sıralı build adımları
```

`sources/`, `build/`, `sysroot/`, `output/` build sırasında oluşur/indirilir
(gitignore'da) — bu repo yalnızca build script'lerini içerir, üretilen
sistemi değil.

## Bilinen kısıtlar

- **WiFi desteklenmiyor** — sadece Ethernet ve USB tethering.
- **Nvidia proprietary sürücü yok** — sadece açık kaynak `nouveau`.
- `btrfs`/`xfs`/`ntfs3` şu an derlenmiyor (ext4/vfat/exfat var).

## Katkıda bulunma

Issue/PR'lar memnuniyetle karşılanır. Script isimlendirmesi kendi kendini
açıklıyor (`<numara>-<paket-adı>.sh`) — yeni bir paket eklemek, bağımlılık
sırasına uygun bir numarayla yeni bir script eklemek demek.

## Lisans

GPLv3 — bkz. [LICENSE](LICENSE). Türevler de açık kaynak kalmak zorunda.
