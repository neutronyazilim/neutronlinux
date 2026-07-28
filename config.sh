#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export LC_ALL=C
export LANG=C

export SOURCES="$ROOT/sources"
export BUILD="$ROOT/build"
export LFS="$ROOT/sysroot"
export TOOLS="$LFS/tools"
export OUTPUT="$ROOT/output"

export TARGET="x86_64-neutron-linux-gnu"
export PATH="$TOOLS/bin:$PATH"

if [ -x "$TOOLS/bin/$TARGET-gcc" ] && [ ! -e "$TOOLS/bin/$TARGET-ld.lld" ] && command -v ld.lld >/dev/null; then
    ln -sf "$(command -v ld.lld)" "$TOOLS/bin/$TARGET-ld.lld"
    ln -sf "$(command -v ld.lld)" "$TOOLS/bin/ld.lld"
fi

BINUTILS_VER=2.42
GCC_VER=13.2.0
GLIBC_VER=2.43
LINUX_VER=6.18.38
BUSYBOX_VER=1.36.1
BASH_VER=5.2.21
ZSH_VER=5.9.2

NCURSES_VER=6.5
LIBXCRYPT_VER=4.4.36
UTIL_LINUX_VER=2.40
LIBCAP_VER=2.69
ACL_VER=2.3.2
ATTR_VER=2.5.2
KMOD_VER=31
EXPAT_VER=2.6.2
PAM_VER=1.6.1
DBUS_VER=1.14.10
SYSTEMD_VER=261.1
COREUTILS_VER=9.11
GREP_VER=3.12
SED_VER=4.10
GAWK_VER=5.4.1
FINDUTILS_VER=4.11.0
DIFFUTILS_VER=3.12
TAR_VER=1.35
GZIP_VER=1.14
XZ_VER=5.8.3
LESS_VER=704
FILE_VER=5.48
WHICH_VER=2.25
PATCH_VER=2.8

XCBUTIL_VER=0.4.1
XCBUTILIMAGE_VER=0.4.1
XCBUTILRENDERUTIL_VER=0.3.10
XCBUTILCURSOR_VER=0.1.6
XCBUTILWM_VER=0.4.2
XCBUTILKEYSYMS_VER=0.4.1
KF6_VER=6.28.0
ECM_VER=6.28.0
KCOREADDONS_VER=6.28.0
KCONFIG_VER=6.28.0
KWIDGETSADDONS_VER=6.28.0
KGUIADDONS_VER=6.28.0
KI18N_VER=6.28.0
KCODECS_VER=6.28.0
KARCHIVE_VER=6.28.0
KITEMVIEWS_VER=6.28.0
KITEMMODELS_VER=6.28.0
KDBUSADDONS_VER=6.28.0
KWINDOWSYSTEM_VER=6.28.0
SOLID_VER=6.28.0
LIBXFIXES_VER=6.0.2
KCONFIGWIDGETS_VER=6.28.0
KCOMPLETION_VER=6.28.0
KCRASH_VER=6.28.0
KGLOBALACCEL_VER=6.28.0
KICONTHEMES_VER=6.28.0
KSERVICE_VER=6.28.0
KNOTIFICATIONS_VER=6.28.0
KJOBWIDGETS_VER=6.28.0
SONNET_VER=6.28.0
KPACKAGE_VER=6.28.0
KCOLORSCHEME_VER=6.28.0
ATTICA_VER=6.28.0
BREEZEICONS_VER=6.28.0
KDECLARATIVE_VER=6.28.0
KXMLGUI_VER=6.28.0
KTEXTWIDGETS_VER=6.28.0
KIO_VER=6.28.0
KCMUTILS_VER=6.28.0
KUNITCONVERSION_VER=6.28.0
PRISON_VER=6.28.0
QRENCODE_VER=4.1.1
KSVG_VER=6.28.0
KBOOKMARKS_VER=6.28.0
KAUTH_VER=6.28.0
KDED_VER=6.28.0
KHOLIDAYS_VER=6.28.0
KIDLETIME_VER=6.28.0
KNEWSTUFF_VER=6.28.0
KPARTS_VER=6.28.0
KRUNNER_VER=6.28.0
KTEXTEDITOR_VER=6.28.0
KWALLET_VER=6.28.0
SYNTAXHIGHLIGHTING_VER=6.28.0
LIBGPGERROR_VER=1.51
LIBGCRYPT_VER=1.11.1
QCA_VER=2.3.10
QT5COMPAT_VER=6.11.1
PCRE2_VER=10.47
GLIB_VER=2.86.5
LIBSECRET_VER=0.21.7
ZSTD_VER=1.5.7
KWAYLAND_VER=6.7.3
KSCREEN_VER=6.7.3
KSCREENLOCKER_VER=6.7.3
LAYERSHELLQT_VER=6.7.3
PLASMAACTIVITIESSTATS_VER=6.7.3
SQLITE_VER=3530300
SQLITE_YEAR=2026
QCORO_VER=0.13.0
ICU_VER=78.3
LIBGLVND_VER=1.7.0
LIBKSCREEN_VER=6.7.3
LIBXI_VER=1.8.2
UTILMACROS_VER=1.20.2
LIBXDAMAGE_VER=1.1.6
LIBXSHMFENCE_VER=1.3.2
LIBXXF86VM_VER=1.1.5
MESA_VER=26.1.5
LIBEPOXY_VER=1.5.10
KDECORATION_VER=6.7.3
KGLOBALACCELD_VER=6.7.3
LIBDISPLAYINFO_VER=0.3.0
QTTOOLS_VER=6.11.1
QTSENSORS_VER=6.11.1
KNIGHTTIME_VER=6.7.3
LCMS2_VER=2.19.1
QTLOCATION_VER=6.11.1
KSTATUSNOTIFIERITEM_VER=6.28.0
NETWORKMANAGERQT_VER=6.28.0
LIBXCURSOR_VER=1.2.3
LIBXTST_VER=1.2.5
LIBOGG_VER=1.3.5
LIBVORBIS_VER=1.3.7
LIBTOOL_VER=2.4.7
ALSALIB_VER=1.2.16.1
TDB_VER=1.4.15
LIBCANBERRA_VER=0.30
LIBNL_VER=3.12.0
LMSENSORS_VER=3-6-2
LIBKSYSGUARD_VER=6.7.3
BOOST_VER=1.91.0
KACTIVITYMANAGERD_VER=6.7.3
LIBXRANDR_VER=1.5.4
STRACE_VER=6.13
GDB_VER=16.2
GMP_VER=6.3.0
MPFR_VER=4.2.1
PLASMA5SUPPORT_VER=6.7.3
KNOTIFYCONFIG_VER=6.28.0
LIBXML2_VER=2.13.9
QTPOSITIONING_VER=6.11.1
QTSPEECH_VER=6.11.1
QTMULTIMEDIA_VER=6.11.1
OPENSSL_VER=3.4.1
LIBXKBCOMMON_VER=1.7.0
QTBASE_VER=6.11.1
QTSVG_VER=6.11.1
QTSHADERTOOLS_VER=6.11.1
QTDECLARATIVE_VER=6.11.1
XORGPROTO_VER=2024.1
XTRANS_VER=1.6.0
ZLIB_VER=1.3.2
FREETYPE_VER=2.13.3
LIBFONTENC_VER=1.1.9
LIBXFONT2_VER=2.0.8
FONTUTIL_VER=1.4.2
LIBXCVT_VER=0.1.3
LIBMD_VER=1.2.0
XCBPROTO_VER=1.17.0
LIBXAU_VER=1.0.11
LIBXDMCP_VER=1.1.5
PIXMAN_VER=0.44.2
LIBDRM_VER=2.4.123
LIBPCIACCESS_VER=0.18.1
LIBXCB_VER=1.17.0
LIBX11_VER=1.8.10
LIBXEXT_VER=1.3.6
LIBXKBFILE_VER=1.1.3
XKEYBOARDCONFIG_VER=2.42
XKBCOMP_VER=1.4.7
XORGSERVER_VER=21.1.15
MTDEV_VER=1.1.7
LIBEVDEV_VER=1.13.6
XF86INPUTEVDEV_VER=2.11.0
LIBXINERAMA_VER=1.1.6
LIBXRENDER_VER=0.9.12
LIBXFT_VER=2.3.9
FONTCONFIG_VER=2.18.2
LIBICE_VER=1.1.2
LIBSM_VER=1.2.6
LIBXT_VER=1.3.1
LIBXMU_VER=1.3.1
XAUTH_VER=1.1.5
DEJAVU_VER=2.37
DWM_VER=6.5
ST_VER=0.9.2
XINIT_VER=1.4.2

LIBFFI_VER=3.4.6
WAYLAND_VER=1.25.0
WAYLANDPROTOCOLS_VER=1.48
PLASMAWAYLANDPROTOCOLS_VER=1.21.0
QTWAYLAND_VER=6.11.1
KIRIGAMI_VER=6.28.0
KIRIGAMIADDONS_VER=1.13.0
PLASMA_VER=6.7.3
SYSTEMSETTINGS_VER=6.7.3
KINFOCENTER_VER=6.7.3
VULKANHEADERS_VER=1.4.328
PLASMAACTIVITIES_VER=6.7.3
LIBPLASMA_VER=6.7.3
PLASMAWORKSPACE_VER=6.7.3
KWIN_VER=6.7.3
PLASMADESKTOP_VER=6.7.3
CALAMARES_VER=3.3.0
CALAMARES_SRC=calamares-$CALAMARES_VER
CALAMARES_SRC=calamares-$CALAMARES_VER
BREEZE_VER=6.7.3
KQUICKCHARTS_VER=6.28.0
KPTY_VER=6.28.0
KFILEMETADATA_VER=6.28.0
HARFBUZZ_VER=14.2.1
CAIRO_VER=1.18.4
FRIBIDI_VER=1.0.16
PANGO_VER=1.58.0
ATK_VER=2.38.0
DUKTAPE_VER=2.7.0
POLKIT_VER=124
LIBGUDEV_VER=238
UDISKS2_VER=2.11.1
SDDM_VER=0.21.0
GDKPIXBUF_VER=2.44.7
GTK3_VER=3.24.52
APPS_VER=26.04.3
KONSOLE_VER=$APPS_VER
DOLPHIN_VER=$APPS_VER
LLVM_VER=22.1.6
LIBXCOMPOSITE_VER=0.4.6
ATSPI2CORE_VER=2.56.8
LIBPNG_VER=1.6.58
NSPR_VER=4.39
NSS_VER=3.126
ELFUTILS_VER=0.192

SOURCES_LIST="
binutils-$BINUTILS_VER.tar.xz https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VER.tar.xz
gcc-$GCC_VER.tar.xz https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VER/gcc-$GCC_VER.tar.xz
glibc-$GLIBC_VER.tar.xz https://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VER.tar.xz
linux-$LINUX_VER.tar.xz https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$LINUX_VER.tar.xz
busybox-$BUSYBOX_VER.tar.bz2 https://busybox.net/downloads/busybox-$BUSYBOX_VER.tar.bz2
bash-$BASH_VER.tar.gz https://ftp.gnu.org/gnu/bash/bash-$BASH_VER.tar.gz
zsh-$ZSH_VER.tar.xz https://sourceforge.net/projects/zsh/files/zsh/$ZSH_VER/zsh-$ZSH_VER.tar.xz
ncurses-$NCURSES_VER.tar.gz https://ftp.gnu.org/gnu/ncurses/ncurses-$NCURSES_VER.tar.gz
libxcrypt-$LIBXCRYPT_VER.tar.xz https://github.com/besser82/libxcrypt/releases/download/v$LIBXCRYPT_VER/libxcrypt-$LIBXCRYPT_VER.tar.xz
util-linux-$UTIL_LINUX_VER.tar.xz https://www.kernel.org/pub/linux/utils/util-linux/v$UTIL_LINUX_VER/util-linux-$UTIL_LINUX_VER.tar.xz
libcap-$LIBCAP_VER.tar.xz https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-$LIBCAP_VER.tar.xz
acl-$ACL_VER.tar.xz https://download.savannah.nongnu.org/releases/acl/acl-$ACL_VER.tar.xz
attr-$ATTR_VER.tar.gz https://download.savannah.nongnu.org/releases/attr/attr-$ATTR_VER.tar.gz
kmod-$KMOD_VER.tar.xz https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-$KMOD_VER.tar.xz
expat-$EXPAT_VER.tar.xz https://github.com/libexpat/libexpat/releases/download/R_$(echo $EXPAT_VER | tr . _)/expat-$EXPAT_VER.tar.xz
Linux-PAM-$PAM_VER.tar.xz https://github.com/linux-pam/linux-pam/releases/download/v$PAM_VER/Linux-PAM-$PAM_VER.tar.xz
dbus-$DBUS_VER.tar.xz https://dbus.freedesktop.org/releases/dbus/dbus-$DBUS_VER.tar.xz
systemd-$SYSTEMD_VER.tar.gz https://github.com/systemd/systemd/archive/refs/tags/v$SYSTEMD_VER.tar.gz
coreutils-$COREUTILS_VER.tar.xz https://ftp.gnu.org/gnu/coreutils/coreutils-$COREUTILS_VER.tar.xz
grep-$GREP_VER.tar.xz https://ftp.gnu.org/gnu/grep/grep-$GREP_VER.tar.xz
sed-$SED_VER.tar.xz https://ftp.gnu.org/gnu/sed/sed-$SED_VER.tar.xz
gawk-$GAWK_VER.tar.xz https://ftp.gnu.org/gnu/gawk/gawk-$GAWK_VER.tar.xz
findutils-$FINDUTILS_VER.tar.xz https://ftp.gnu.org/gnu/findutils/findutils-$FINDUTILS_VER.tar.xz
diffutils-$DIFFUTILS_VER.tar.xz https://ftp.gnu.org/gnu/diffutils/diffutils-$DIFFUTILS_VER.tar.xz
tar-$TAR_VER.tar.xz https://ftp.gnu.org/gnu/tar/tar-$TAR_VER.tar.xz
gzip-$GZIP_VER.tar.xz https://ftp.gnu.org/gnu/gzip/gzip-$GZIP_VER.tar.xz
xz-$XZ_VER.tar.xz https://github.com/tukaani-project/xz/releases/download/v$XZ_VER/xz-$XZ_VER.tar.xz
less-$LESS_VER.tar.gz https://www.greenwoodsoftware.com/less/less-$LESS_VER.tar.gz
file-$FILE_VER.tar.gz https://astron.com/pub/file/file-$FILE_VER.tar.gz
which-$WHICH_VER.tar.gz https://ftp.gnu.org/gnu/which/which-$WHICH_VER.tar.gz
patch-$PATCH_VER.tar.xz https://ftp.gnu.org/gnu/patch/patch-$PATCH_VER.tar.xz
xcb-util-$XCBUTIL_VER.tar.xz https://xcb.freedesktop.org/dist/xcb-util-$XCBUTIL_VER.tar.xz
xcb-util-image-$XCBUTILIMAGE_VER.tar.xz https://xcb.freedesktop.org/dist/xcb-util-image-$XCBUTILIMAGE_VER.tar.xz
xcb-util-renderutil-$XCBUTILRENDERUTIL_VER.tar.xz https://xcb.freedesktop.org/dist/xcb-util-renderutil-$XCBUTILRENDERUTIL_VER.tar.xz
xcb-util-cursor-$XCBUTILCURSOR_VER.tar.xz https://xcb.freedesktop.org/dist/xcb-util-cursor-$XCBUTILCURSOR_VER.tar.xz
xcb-util-wm-$XCBUTILWM_VER.tar.xz https://xcb.freedesktop.org/dist/xcb-util-wm-$XCBUTILWM_VER.tar.xz
xcb-util-keysyms-$XCBUTILKEYSYMS_VER.tar.xz https://xcb.freedesktop.org/dist/xcb-util-keysyms-$XCBUTILKEYSYMS_VER.tar.xz
libxkbcommon-$LIBXKBCOMMON_VER.tar.gz https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-$LIBXKBCOMMON_VER.tar.gz
extra-cmake-modules-$ECM_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/extra-cmake-modules-$ECM_VER.tar.xz
kcoreaddons-$KCOREADDONS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kcoreaddons-$KCOREADDONS_VER.tar.xz
kconfig-$KCONFIG_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kconfig-$KCONFIG_VER.tar.xz
kwidgetsaddons-$KWIDGETSADDONS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kwidgetsaddons-$KWIDGETSADDONS_VER.tar.xz
kguiaddons-$KGUIADDONS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kguiaddons-$KGUIADDONS_VER.tar.xz
ki18n-$KI18N_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/ki18n-$KI18N_VER.tar.xz
kcodecs-$KCODECS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kcodecs-$KCODECS_VER.tar.xz
karchive-$KARCHIVE_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/karchive-$KARCHIVE_VER.tar.xz
kitemviews-$KITEMVIEWS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kitemviews-$KITEMVIEWS_VER.tar.xz
kitemmodels-$KITEMMODELS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kitemmodels-$KITEMMODELS_VER.tar.xz
kdbusaddons-$KDBUSADDONS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kdbusaddons-$KDBUSADDONS_VER.tar.xz
kwindowsystem-$KWINDOWSYSTEM_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kwindowsystem-$KWINDOWSYSTEM_VER.tar.xz
solid-$SOLID_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/solid-$SOLID_VER.tar.xz
libXfixes-$LIBXFIXES_VER.tar.xz https://www.x.org/releases/individual/lib/libXfixes-$LIBXFIXES_VER.tar.xz
kconfigwidgets-$KCONFIGWIDGETS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kconfigwidgets-$KCONFIGWIDGETS_VER.tar.xz
kcompletion-$KCOMPLETION_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kcompletion-$KCOMPLETION_VER.tar.xz
kcrash-$KCRASH_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kcrash-$KCRASH_VER.tar.xz
kglobalaccel-$KGLOBALACCEL_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kglobalaccel-$KGLOBALACCEL_VER.tar.xz
kiconthemes-$KICONTHEMES_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kiconthemes-$KICONTHEMES_VER.tar.xz
kservice-$KSERVICE_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kservice-$KSERVICE_VER.tar.xz
knotifications-$KNOTIFICATIONS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/knotifications-$KNOTIFICATIONS_VER.tar.xz
kstatusnotifieritem-$KSTATUSNOTIFIERITEM_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kstatusnotifieritem-$KSTATUSNOTIFIERITEM_VER.tar.xz
networkmanager-qt-$NETWORKMANAGERQT_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/networkmanager-qt-$NETWORKMANAGERQT_VER.tar.xz
libXcursor-$LIBXCURSOR_VER.tar.xz https://www.x.org/releases/individual/lib/libXcursor-$LIBXCURSOR_VER.tar.xz
libXtst-$LIBXTST_VER.tar.xz https://www.x.org/releases/individual/lib/libXtst-$LIBXTST_VER.tar.xz
libogg-$LIBOGG_VER.tar.xz https://downloads.xiph.org/releases/ogg/libogg-$LIBOGG_VER.tar.xz
libvorbis-$LIBVORBIS_VER.tar.xz https://downloads.xiph.org/releases/vorbis/libvorbis-$LIBVORBIS_VER.tar.xz
libtool-$LIBTOOL_VER.tar.xz https://ftpmirror.gnu.org/gnu/libtool/libtool-$LIBTOOL_VER.tar.xz
alsa-lib-$ALSALIB_VER.tar.bz2 https://www.alsa-project.org/files/pub/lib/alsa-lib-$ALSALIB_VER.tar.bz2
tdb-$TDB_VER.tar.gz https://www.samba.org/ftp/tdb/tdb-$TDB_VER.tar.gz
libcanberra-$LIBCANBERRA_VER.tar.gz https://github.com/Distrotech/libcanberra/archive/refs/tags/v$LIBCANBERRA_VER.tar.gz
libnl-$LIBNL_VER.tar.gz https://github.com/thom311/libnl/releases/download/libnl3_12_0/libnl-$LIBNL_VER.tar.gz
lm-sensors-$LMSENSORS_VER.tar.gz https://github.com/lm-sensors/lm-sensors/archive/refs/tags/V$LMSENSORS_VER.tar.gz
libksysguard-$LIBKSYSGUARD_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/libksysguard-$LIBKSYSGUARD_VER.tar.xz
boost_1_91_0.tar.gz https://archives.boost.io/release/$BOOST_VER/source/boost_1_91_0.tar.gz
kactivitymanagerd-$KACTIVITYMANAGERD_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/kactivitymanagerd-$KACTIVITYMANAGERD_VER.tar.xz
libXrandr-$LIBXRANDR_VER.tar.xz https://www.x.org/releases/individual/lib/libXrandr-$LIBXRANDR_VER.tar.xz
strace-$STRACE_VER.tar.xz https://strace.io/files/$STRACE_VER/strace-$STRACE_VER.tar.xz
gdb-$GDB_VER.tar.xz https://ftp.gnu.org/gnu/gdb/gdb-$GDB_VER.tar.xz
gmp-$GMP_VER.tar.xz https://ftp.gnu.org/gnu/gmp/gmp-$GMP_VER.tar.xz
mpfr-$MPFR_VER.tar.xz https://ftp.gnu.org/gnu/mpfr/mpfr-$MPFR_VER.tar.xz
plasma5support-$PLASMA5SUPPORT_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/plasma5support-$PLASMA5SUPPORT_VER.tar.xz
knotifyconfig-$KNOTIFYCONFIG_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/knotifyconfig-$KNOTIFYCONFIG_VER.tar.xz
libxml2-$LIBXML2_VER.tar.xz https://download.gnome.org/sources/libxml2/2.13/libxml2-$LIBXML2_VER.tar.xz
kjobwidgets-$KJOBWIDGETS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kjobwidgets-$KJOBWIDGETS_VER.tar.xz
sonnet-$SONNET_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/sonnet-$SONNET_VER.tar.xz
kpackage-$KPACKAGE_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kpackage-$KPACKAGE_VER.tar.xz
kcolorscheme-$KCOLORSCHEME_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kcolorscheme-$KCOLORSCHEME_VER.tar.xz
attica-$ATTICA_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/attica-$ATTICA_VER.tar.xz
breeze-icons-$BREEZEICONS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/breeze-icons-$BREEZEICONS_VER.tar.xz
kdeclarative-$KDECLARATIVE_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kdeclarative-$KDECLARATIVE_VER.tar.xz
kxmlgui-$KXMLGUI_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kxmlgui-$KXMLGUI_VER.tar.xz
ktextwidgets-$KTEXTWIDGETS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/ktextwidgets-$KTEXTWIDGETS_VER.tar.xz
kio-$KIO_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kio-$KIO_VER.tar.xz
kcmutils-$KCMUTILS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kcmutils-$KCMUTILS_VER.tar.xz
kunitconversion-$KUNITCONVERSION_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kunitconversion-$KUNITCONVERSION_VER.tar.xz
prison-$PRISON_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/prison-$PRISON_VER.tar.xz
qrencode-$QRENCODE_VER.tar.gz https://github.com/fukuchi/libqrencode/archive/refs/tags/v$QRENCODE_VER.tar.gz
ksvg-$KSVG_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/ksvg-$KSVG_VER.tar.xz
kbookmarks-$KBOOKMARKS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kbookmarks-$KBOOKMARKS_VER.tar.xz
kauth-$KAUTH_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kauth-$KAUTH_VER.tar.xz
kded-$KDED_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kded-$KDED_VER.tar.xz
kholidays-$KHOLIDAYS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kholidays-$KHOLIDAYS_VER.tar.xz
kidletime-$KIDLETIME_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kidletime-$KIDLETIME_VER.tar.xz
knewstuff-$KNEWSTUFF_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/knewstuff-$KNEWSTUFF_VER.tar.xz
kparts-$KPARTS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kparts-$KPARTS_VER.tar.xz
krunner-$KRUNNER_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/krunner-$KRUNNER_VER.tar.xz
ktexteditor-$KTEXTEDITOR_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/ktexteditor-$KTEXTEDITOR_VER.tar.xz
kwallet-$KWALLET_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kwallet-$KWALLET_VER.tar.xz
syntax-highlighting-$SYNTAXHIGHLIGHTING_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/syntax-highlighting-$SYNTAXHIGHLIGHTING_VER.tar.xz
libgpg-error-$LIBGPGERROR_VER.tar.bz2 https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$LIBGPGERROR_VER.tar.bz2
libgcrypt-$LIBGCRYPT_VER.tar.bz2 https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$LIBGCRYPT_VER.tar.bz2
qca-$QCA_VER.tar.xz https://download.kde.org/Attic/qca/$QCA_VER/qca-$QCA_VER.tar.xz
qt5compat-everywhere-src-$QT5COMPAT_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QT5COMPAT_VER/submodules/qt5compat-everywhere-src-$QT5COMPAT_VER.tar.xz
pcre2-$PCRE2_VER.tar.bz2 https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VER/pcre2-$PCRE2_VER.tar.bz2
glib-$GLIB_VER.tar.xz https://download.gnome.org/sources/glib/2.86/glib-$GLIB_VER.tar.xz
libsecret-$LIBSECRET_VER.tar.xz https://download.gnome.org/sources/libsecret/0.21/libsecret-$LIBSECRET_VER.tar.xz
zstd-$ZSTD_VER.tar.gz https://github.com/facebook/zstd/releases/download/v$ZSTD_VER/zstd-$ZSTD_VER.tar.gz
kwayland-$KWAYLAND_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/kwayland-$KWAYLAND_VER.tar.xz
kscreen-$KSCREEN_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/kscreen-$KSCREEN_VER.tar.xz
kscreenlocker-$KSCREENLOCKER_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/kscreenlocker-$KSCREENLOCKER_VER.tar.xz
layer-shell-qt-$LAYERSHELLQT_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/layer-shell-qt-$LAYERSHELLQT_VER.tar.xz
plasma-activities-stats-$PLASMAACTIVITIESSTATS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/plasma-activities-stats-$PLASMAACTIVITIESSTATS_VER.tar.xz
sqlite-autoconf-$SQLITE_VER.tar.gz https://sqlite.org/$SQLITE_YEAR/sqlite-autoconf-$SQLITE_VER.tar.gz
qcoro-$QCORO_VER.tar.gz https://github.com/qcoro/qcoro/archive/refs/tags/v$QCORO_VER.tar.gz
icu4c-$ICU_VER-sources.tgz https://github.com/unicode-org/icu/releases/download/release-$ICU_VER/icu4c-$ICU_VER-sources.tgz
libglvnd-v$LIBGLVND_VER.tar.gz https://gitlab.freedesktop.org/glvnd/libglvnd/-/archive/v$LIBGLVND_VER/libglvnd-v$LIBGLVND_VER.tar.gz
libkscreen-$LIBKSCREEN_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/libkscreen-$LIBKSCREEN_VER.tar.xz
libXi-$LIBXI_VER.tar.xz https://www.x.org/releases/individual/lib/libXi-$LIBXI_VER.tar.xz
util-macros-$UTILMACROS_VER.tar.xz https://www.x.org/releases/individual/util/util-macros-$UTILMACROS_VER.tar.xz
libXdamage-$LIBXDAMAGE_VER.tar.xz https://www.x.org/releases/individual/lib/libXdamage-$LIBXDAMAGE_VER.tar.xz
libxshmfence-$LIBXSHMFENCE_VER.tar.xz https://www.x.org/releases/individual/lib/libxshmfence-$LIBXSHMFENCE_VER.tar.xz
libXxf86vm-$LIBXXF86VM_VER.tar.xz https://www.x.org/releases/individual/lib/libXxf86vm-$LIBXXF86VM_VER.tar.xz
mesa-$MESA_VER.tar.xz https://archive.mesa3d.org/mesa-$MESA_VER.tar.xz
libepoxy-$LIBEPOXY_VER.tar.gz https://github.com/anholt/libepoxy/archive/refs/tags/$LIBEPOXY_VER.tar.gz
kdecoration-$KDECORATION_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/kdecoration-$KDECORATION_VER.tar.xz
kglobalacceld-$KGLOBALACCELD_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/kglobalacceld-$KGLOBALACCELD_VER.tar.xz
libdisplay-info-$LIBDISPLAYINFO_VER.tar.gz https://gitlab.freedesktop.org/emersion/libdisplay-info/-/archive/$LIBDISPLAYINFO_VER/libdisplay-info-$LIBDISPLAYINFO_VER.tar.gz
qtspeech-everywhere-src-$QTSPEECH_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTSPEECH_VER/submodules/qtspeech-everywhere-src-$QTSPEECH_VER.tar.xz
qtmultimedia-everywhere-src-$QTMULTIMEDIA_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTMULTIMEDIA_VER/submodules/qtmultimedia-everywhere-src-$QTMULTIMEDIA_VER.tar.xz
openssl-$OPENSSL_VER.tar.gz https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz
qtbase-everywhere-src-$QTBASE_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTBASE_VER/submodules/qtbase-everywhere-src-$QTBASE_VER.tar.xz
qtsvg-everywhere-src-$QTSVG_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTSVG_VER/submodules/qtsvg-everywhere-src-$QTSVG_VER.tar.xz
qtshadertools-everywhere-src-$QTSHADERTOOLS_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTSHADERTOOLS_VER/submodules/qtshadertools-everywhere-src-$QTSHADERTOOLS_VER.tar.xz
qtdeclarative-everywhere-src-$QTDECLARATIVE_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTDECLARATIVE_VER/submodules/qtdeclarative-everywhere-src-$QTDECLARATIVE_VER.tar.xz
xorgproto-$XORGPROTO_VER.tar.xz https://www.x.org/releases/individual/proto/xorgproto-$XORGPROTO_VER.tar.xz
xtrans-$XTRANS_VER.tar.xz https://www.x.org/releases/individual/lib/xtrans-$XTRANS_VER.tar.xz
zlib-$ZLIB_VER.tar.gz https://zlib.net/zlib-$ZLIB_VER.tar.gz
freetype-$FREETYPE_VER.tar.xz https://downloads.sourceforge.net/project/freetype/freetype2/$FREETYPE_VER/freetype-$FREETYPE_VER.tar.xz
libfontenc-$LIBFONTENC_VER.tar.xz https://www.x.org/releases/individual/lib/libfontenc-$LIBFONTENC_VER.tar.xz
libXfont2-$LIBXFONT2_VER.tar.xz https://www.x.org/releases/individual/lib/libXfont2-$LIBXFONT2_VER.tar.xz
font-util-$FONTUTIL_VER.tar.xz https://www.x.org/releases/individual/font/font-util-$FONTUTIL_VER.tar.xz
libxcvt-$LIBXCVT_VER.tar.xz https://www.x.org/releases/individual/lib/libxcvt-$LIBXCVT_VER.tar.xz
libmd-$LIBMD_VER.tar.xz https://archive.hadrons.org/software/libmd/libmd-$LIBMD_VER.tar.xz
xcb-proto-$XCBPROTO_VER.tar.xz https://xcb.freedesktop.org/dist/xcb-proto-$XCBPROTO_VER.tar.xz
libXau-$LIBXAU_VER.tar.xz https://www.x.org/releases/individual/lib/libXau-$LIBXAU_VER.tar.xz
libXdmcp-$LIBXDMCP_VER.tar.xz https://www.x.org/releases/individual/lib/libXdmcp-$LIBXDMCP_VER.tar.xz
pixman-$PIXMAN_VER.tar.gz https://www.cairographics.org/releases/pixman-$PIXMAN_VER.tar.gz
libdrm-$LIBDRM_VER.tar.xz https://dri.freedesktop.org/libdrm/libdrm-$LIBDRM_VER.tar.xz
libpciaccess-$LIBPCIACCESS_VER.tar.xz https://www.x.org/releases/individual/lib/libpciaccess-$LIBPCIACCESS_VER.tar.xz
libxcb-$LIBXCB_VER.tar.xz https://xcb.freedesktop.org/dist/libxcb-$LIBXCB_VER.tar.xz
libX11-$LIBX11_VER.tar.xz https://www.x.org/releases/individual/lib/libX11-$LIBX11_VER.tar.xz
libXext-$LIBXEXT_VER.tar.xz https://www.x.org/releases/individual/lib/libXext-$LIBXEXT_VER.tar.xz
libxkbfile-$LIBXKBFILE_VER.tar.xz https://www.x.org/releases/individual/lib/libxkbfile-$LIBXKBFILE_VER.tar.xz
xkeyboard-config-$XKEYBOARDCONFIG_VER.tar.xz https://www.x.org/releases/individual/data/xkeyboard-config/xkeyboard-config-$XKEYBOARDCONFIG_VER.tar.xz
xkbcomp-$XKBCOMP_VER.tar.xz https://www.x.org/releases/individual/app/xkbcomp-$XKBCOMP_VER.tar.xz
xorg-server-$XORGSERVER_VER.tar.xz https://www.x.org/releases/individual/xserver/xorg-server-$XORGSERVER_VER.tar.xz
mtdev-$MTDEV_VER.tar.bz2 https://bitmath.se/org/code/mtdev/mtdev-$MTDEV_VER.tar.bz2
libevdev-$LIBEVDEV_VER.tar.xz https://www.freedesktop.org/software/libevdev/libevdev-$LIBEVDEV_VER.tar.xz
xf86-input-evdev-$XF86INPUTEVDEV_VER.tar.xz https://www.x.org/releases/individual/driver/xf86-input-evdev-$XF86INPUTEVDEV_VER.tar.xz
libXinerama-$LIBXINERAMA_VER.tar.xz https://www.x.org/releases/individual/lib/libXinerama-$LIBXINERAMA_VER.tar.xz
libXrender-$LIBXRENDER_VER.tar.xz https://www.x.org/releases/individual/lib/libXrender-$LIBXRENDER_VER.tar.xz
libXft-$LIBXFT_VER.tar.xz https://www.x.org/releases/individual/lib/libXft-$LIBXFT_VER.tar.xz
fontconfig-$FONTCONFIG_VER.tar.xz https://gitlab.freedesktop.org/api/v4/projects/890/packages/generic/fontconfig/$FONTCONFIG_VER/fontconfig-$FONTCONFIG_VER.tar.xz
libICE-$LIBICE_VER.tar.xz https://www.x.org/releases/individual/lib/libICE-$LIBICE_VER.tar.xz
libSM-$LIBSM_VER.tar.xz https://www.x.org/releases/individual/lib/libSM-$LIBSM_VER.tar.xz
libXt-$LIBXT_VER.tar.xz https://www.x.org/releases/individual/lib/libXt-$LIBXT_VER.tar.xz
libXmu-$LIBXMU_VER.tar.xz https://www.x.org/releases/individual/lib/libXmu-$LIBXMU_VER.tar.xz
xauth-$XAUTH_VER.tar.xz https://www.x.org/releases/individual/app/xauth-$XAUTH_VER.tar.xz
dejavu-fonts-ttf-$DEJAVU_VER.tar.bz2 https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_$(echo $DEJAVU_VER | tr . _)/dejavu-fonts-ttf-$DEJAVU_VER.tar.bz2
dwm-$DWM_VER.tar.gz https://dl.suckless.org/dwm/dwm-$DWM_VER.tar.gz
st-$ST_VER.tar.gz https://dl.suckless.org/st/st-$ST_VER.tar.gz
xinit-$XINIT_VER.tar.xz https://www.x.org/releases/individual/app/xinit-$XINIT_VER.tar.xz
libffi-$LIBFFI_VER.tar.gz https://github.com/libffi/libffi/releases/download/v$LIBFFI_VER/libffi-$LIBFFI_VER.tar.gz
wayland-$WAYLAND_VER.tar.xz https://gitlab.freedesktop.org/wayland/wayland/-/releases/$WAYLAND_VER/downloads/wayland-$WAYLAND_VER.tar.xz
wayland-protocols-$WAYLANDPROTOCOLS_VER.tar.xz https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/$WAYLANDPROTOCOLS_VER/downloads/wayland-protocols-$WAYLANDPROTOCOLS_VER.tar.xz
plasma-wayland-protocols-$PLASMAWAYLANDPROTOCOLS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma-wayland-protocols/plasma-wayland-protocols-$PLASMAWAYLANDPROTOCOLS_VER.tar.xz
qtwayland-everywhere-src-$QTWAYLAND_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTWAYLAND_VER/submodules/qtwayland-everywhere-src-$QTWAYLAND_VER.tar.xz
qttools-everywhere-src-$QTTOOLS_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTTOOLS_VER/submodules/qttools-everywhere-src-$QTTOOLS_VER.tar.xz
qtsensors-everywhere-src-$QTSENSORS_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTSENSORS_VER/submodules/qtsensors-everywhere-src-$QTSENSORS_VER.tar.xz
knighttime-$KNIGHTTIME_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/knighttime-$KNIGHTTIME_VER.tar.xz
lcms2-$LCMS2_VER.tar.gz https://github.com/mm2/Little-CMS/releases/download/lcms$LCMS2_VER/lcms2-$LCMS2_VER.tar.gz
qtpositioning-everywhere-src-$QTPOSITIONING_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTPOSITIONING_VER/submodules/qtpositioning-everywhere-src-$QTPOSITIONING_VER.tar.xz
qtlocation-everywhere-src-$QTLOCATION_VER.tar.xz https://download.qt.io/official_releases/qt/6.11/$QTLOCATION_VER/submodules/qtlocation-everywhere-src-$QTLOCATION_VER.tar.xz
kirigami-$KIRIGAMI_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kirigami-$KIRIGAMI_VER.tar.xz
kirigami-addons-$KIRIGAMIADDONS_VER.tar.xz https://download.kde.org/stable/kirigami-addons/kirigami-addons-$KIRIGAMIADDONS_VER.tar.xz
plasma-activities-$PLASMAACTIVITIES_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/plasma-activities-$PLASMAACTIVITIES_VER.tar.xz
libplasma-$LIBPLASMA_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/libplasma-$LIBPLASMA_VER.tar.xz
plasma-workspace-$PLASMAWORKSPACE_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/plasma-workspace-$PLASMAWORKSPACE_VER.tar.xz
kwin-x11-$KWIN_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/kwin-x11-$KWIN_VER.tar.xz
plasma-desktop-$PLASMADESKTOP_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/plasma-desktop-$PLASMADESKTOP_VER.tar.xz
systemsettings-$SYSTEMSETTINGS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/systemsettings-$SYSTEMSETTINGS_VER.tar.xz
kinfocenter-$KINFOCENTER_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/kinfocenter-$KINFOCENTER_VER.tar.xz
Vulkan-Headers-$VULKANHEADERS_VER.tar.gz https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/v$VULKANHEADERS_VER.tar.gz
breeze-$BREEZE_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/plasma/$PLASMA_VER/breeze-$BREEZE_VER.tar.xz
kquickcharts-$KQUICKCHARTS_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kquickcharts-$KQUICKCHARTS_VER.tar.xz
kpty-$KPTY_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kpty-$KPTY_VER.tar.xz
kfilemetadata-$KFILEMETADATA_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/frameworks/6.28/kfilemetadata-$KFILEMETADATA_VER.tar.xz
harfbuzz-$HARFBUZZ_VER.tar.xz https://github.com/harfbuzz/harfbuzz/releases/download/$HARFBUZZ_VER/harfbuzz-$HARFBUZZ_VER.tar.xz
cairo-$CAIRO_VER.tar.xz https://cairographics.org/releases/cairo-$CAIRO_VER.tar.xz
fribidi-$FRIBIDI_VER.tar.xz https://github.com/fribidi/fribidi/releases/download/v$FRIBIDI_VER/fribidi-$FRIBIDI_VER.tar.xz
pango-$PANGO_VER.tar.xz https://download.gnome.org/sources/pango/1.58/pango-$PANGO_VER.tar.xz
atk-$ATK_VER.tar.xz https://download.gnome.org/sources/atk/2.38/atk-$ATK_VER.tar.xz
duktape-$DUKTAPE_VER.tar.xz https://duktape.org/duktape-$DUKTAPE_VER.tar.xz
polkit-$POLKIT_VER.tar.bz2 https://gitlab.freedesktop.org/polkit/polkit/-/archive/$POLKIT_VER/polkit-$POLKIT_VER.tar.bz2
libgudev-$LIBGUDEV_VER.tar.xz https://download.gnome.org/sources/libgudev/238/libgudev-$LIBGUDEV_VER.tar.xz
udisks-$UDISKS2_VER.tar.bz2 https://github.com/storaged-project/udisks/releases/download/udisks-$UDISKS2_VER/udisks-$UDISKS2_VER.tar.bz2
sddm-$SDDM_VER.tar.gz https://github.com/sddm/sddm/archive/refs/tags/v$SDDM_VER.tar.gz
gdk-pixbuf-$GDKPIXBUF_VER.tar.xz https://download.gnome.org/sources/gdk-pixbuf/2.44/gdk-pixbuf-$GDKPIXBUF_VER.tar.xz
gtk-$GTK3_VER.tar.xz https://download.gnome.org/sources/gtk/3.24/gtk-$GTK3_VER.tar.xz
konsole-$KONSOLE_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/release-service/$APPS_VER/src/konsole-$KONSOLE_VER.tar.xz
dolphin-$DOLPHIN_VER.tar.xz https://mirrors.dotsrc.org/kde/stable/release-service/$APPS_VER/src/dolphin-$DOLPHIN_VER.tar.xz
llvm-project-$LLVM_VER.src.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-$LLVM_VER/llvm-project-$LLVM_VER.src.tar.xz
libXcomposite-$LIBXCOMPOSITE_VER.tar.xz https://www.x.org/releases/individual/lib/libXcomposite-$LIBXCOMPOSITE_VER.tar.xz
at-spi2-core-$ATSPI2CORE_VER.tar.xz https://download.gnome.org/sources/at-spi2-core/2.56/at-spi2-core-$ATSPI2CORE_VER.tar.xz
libpng-$LIBPNG_VER.tar.xz http://downloads.sourceforge.net/project/libpng/libpng16/$LIBPNG_VER/libpng-$LIBPNG_VER.tar.xz
nspr-$NSPR_VER.tar.gz https://ftp.mozilla.org/pub/nspr/releases/v$NSPR_VER/src/nspr-$NSPR_VER.tar.gz
nss-$NSS_VER.tar.gz https://ftp.mozilla.org/pub/security/nss/releases/NSS_${NSS_VER//./_}_RTM/src/nss-$NSS_VER.tar.gz
"

BINUTILS_SRC="binutils-$BINUTILS_VER"
GCC_SRC="gcc-$GCC_VER"
GLIBC_SRC="glibc-$GLIBC_VER"
LINUX_SRC="linux-$LINUX_VER"
BUSYBOX_SRC="busybox-$BUSYBOX_VER"
BASH_SRC="bash-$BASH_VER"
ZSH_SRC="zsh-$ZSH_VER"
NCURSES_SRC="ncurses-$NCURSES_VER"
LIBXCRYPT_SRC="libxcrypt-$LIBXCRYPT_VER"
UTIL_LINUX_SRC="util-linux-$UTIL_LINUX_VER"
LIBCAP_SRC="libcap-$LIBCAP_VER"
ACL_SRC="acl-$ACL_VER"
ATTR_SRC="attr-$ATTR_VER"
KMOD_SRC="kmod-$KMOD_VER"
EXPAT_SRC="expat-$EXPAT_VER"
PAM_SRC="Linux-PAM-$PAM_VER"
DBUS_SRC="dbus-$DBUS_VER"
SYSTEMD_SRC="systemd-$SYSTEMD_VER"
COREUTILS_SRC="coreutils-$COREUTILS_VER"
GREP_SRC="grep-$GREP_VER"
SED_SRC="sed-$SED_VER"
GAWK_SRC="gawk-$GAWK_VER"
FINDUTILS_SRC="findutils-$FINDUTILS_VER"
DIFFUTILS_SRC="diffutils-$DIFFUTILS_VER"
TAR_SRC="tar-$TAR_VER"
GZIP_SRC="gzip-$GZIP_VER"
XZ_SRC="xz-$XZ_VER"
LESS_SRC="less-$LESS_VER"
FILE_SRC="file-$FILE_VER"
WHICH_SRC="which-$WHICH_VER"
PATCH_SRC="patch-$PATCH_VER"
XCBUTIL_SRC="xcb-util-$XCBUTIL_VER"
XCBUTILIMAGE_SRC="xcb-util-image-$XCBUTILIMAGE_VER"
XCBUTILRENDERUTIL_SRC="xcb-util-renderutil-$XCBUTILRENDERUTIL_VER"
XCBUTILCURSOR_SRC="xcb-util-cursor-$XCBUTILCURSOR_VER"
XCBUTILWM_SRC="xcb-util-wm-$XCBUTILWM_VER"
XCBUTILKEYSYMS_SRC="xcb-util-keysyms-$XCBUTILKEYSYMS_VER"
LIBXKBCOMMON_SRC="libxkbcommon-xkbcommon-$LIBXKBCOMMON_VER"
ECM_SRC="extra-cmake-modules-$ECM_VER"
KCOREADDONS_SRC="kcoreaddons-$KCOREADDONS_VER"
KCONFIG_SRC="kconfig-$KCONFIG_VER"
KWIDGETSADDONS_SRC="kwidgetsaddons-$KWIDGETSADDONS_VER"
KGUIADDONS_SRC="kguiaddons-$KGUIADDONS_VER"
KI18N_SRC="ki18n-$KI18N_VER"
KCODECS_SRC="kcodecs-$KCODECS_VER"
KARCHIVE_SRC="karchive-$KARCHIVE_VER"
KITEMVIEWS_SRC="kitemviews-$KITEMVIEWS_VER"
KITEMMODELS_SRC="kitemmodels-$KITEMMODELS_VER"
KDBUSADDONS_SRC="kdbusaddons-$KDBUSADDONS_VER"
KWINDOWSYSTEM_SRC="kwindowsystem-$KWINDOWSYSTEM_VER"
SOLID_SRC="solid-$SOLID_VER"
LIBXFIXES_SRC="libXfixes-$LIBXFIXES_VER"
KCONFIGWIDGETS_SRC="kconfigwidgets-$KCONFIGWIDGETS_VER"
KCOMPLETION_SRC="kcompletion-$KCOMPLETION_VER"
KCRASH_SRC="kcrash-$KCRASH_VER"
KGLOBALACCEL_SRC="kglobalaccel-$KGLOBALACCEL_VER"
KICONTHEMES_SRC="kiconthemes-$KICONTHEMES_VER"
KSERVICE_SRC="kservice-$KSERVICE_VER"
KNOTIFICATIONS_SRC="knotifications-$KNOTIFICATIONS_VER"
KSTATUSNOTIFIERITEM_SRC="kstatusnotifieritem-$KSTATUSNOTIFIERITEM_VER"
NETWORKMANAGERQT_SRC="networkmanager-qt-$NETWORKMANAGERQT_VER"
LIBXCURSOR_SRC="libXcursor-$LIBXCURSOR_VER"
LIBXTST_SRC="libXtst-$LIBXTST_VER"
LIBOGG_SRC="libogg-$LIBOGG_VER"
LIBVORBIS_SRC="libvorbis-$LIBVORBIS_VER"
LIBTOOL_SRC="libtool-$LIBTOOL_VER"
ALSALIB_SRC="alsa-lib-$ALSALIB_VER"
TDB_SRC="tdb-$TDB_VER"
LIBCANBERRA_SRC="libcanberra-$LIBCANBERRA_VER"
LIBNL_SRC="libnl-$LIBNL_VER"
LMSENSORS_SRC="lm-sensors-$LMSENSORS_VER"
LIBKSYSGUARD_SRC="libksysguard-$LIBKSYSGUARD_VER"
BOOST_SRC="boost_1_91_0"
KACTIVITYMANAGERD_SRC="kactivitymanagerd-$KACTIVITYMANAGERD_VER"
LIBXRANDR_SRC="libXrandr-$LIBXRANDR_VER"
STRACE_SRC="strace-$STRACE_VER"
GDB_SRC="gdb-$GDB_VER"
GMP_SRC="gmp-$GMP_VER"
MPFR_SRC="mpfr-$MPFR_VER"
PLASMA5SUPPORT_SRC="plasma5support-$PLASMA5SUPPORT_VER"
KNOTIFYCONFIG_SRC="knotifyconfig-$KNOTIFYCONFIG_VER"
LIBXML2_SRC="libxml2-$LIBXML2_VER"
KJOBWIDGETS_SRC="kjobwidgets-$KJOBWIDGETS_VER"
SONNET_SRC="sonnet-$SONNET_VER"
KPACKAGE_SRC="kpackage-$KPACKAGE_VER"
KCOLORSCHEME_SRC="kcolorscheme-$KCOLORSCHEME_VER"
ATTICA_SRC="attica-$ATTICA_VER"
BREEZEICONS_SRC="breeze-icons-$BREEZEICONS_VER"
KDECLARATIVE_SRC="kdeclarative-$KDECLARATIVE_VER"
KXMLGUI_SRC="kxmlgui-$KXMLGUI_VER"
KTEXTWIDGETS_SRC="ktextwidgets-$KTEXTWIDGETS_VER"
KIO_SRC="kio-$KIO_VER"
KCMUTILS_SRC="kcmutils-$KCMUTILS_VER"
KUNITCONVERSION_SRC="kunitconversion-$KUNITCONVERSION_VER"
PRISON_SRC="prison-$PRISON_VER"
QRENCODE_SRC="libqrencode-$QRENCODE_VER"
KSVG_SRC="ksvg-$KSVG_VER"
KBOOKMARKS_SRC="kbookmarks-$KBOOKMARKS_VER"
KAUTH_SRC="kauth-$KAUTH_VER"
KDED_SRC="kded-$KDED_VER"
KHOLIDAYS_SRC="kholidays-$KHOLIDAYS_VER"
KIDLETIME_SRC="kidletime-$KIDLETIME_VER"
KNEWSTUFF_SRC="knewstuff-$KNEWSTUFF_VER"
KPARTS_SRC="kparts-$KPARTS_VER"
KRUNNER_SRC="krunner-$KRUNNER_VER"
KTEXTEDITOR_SRC="ktexteditor-$KTEXTEDITOR_VER"
KWALLET_SRC="kwallet-$KWALLET_VER"
SYNTAXHIGHLIGHTING_SRC="syntax-highlighting-$SYNTAXHIGHLIGHTING_VER"
LIBGPGERROR_SRC="libgpg-error-$LIBGPGERROR_VER"
LIBGCRYPT_SRC="libgcrypt-$LIBGCRYPT_VER"
QCA_SRC="qca-$QCA_VER"
QT5COMPAT_SRC="qt5compat-everywhere-src-$QT5COMPAT_VER"
PCRE2_SRC="pcre2-$PCRE2_VER"
GLIB_SRC="glib-$GLIB_VER"
LIBSECRET_SRC="libsecret-$LIBSECRET_VER"
ZSTD_SRC="zstd-$ZSTD_VER"
KWAYLAND_SRC="kwayland-$KWAYLAND_VER"
KSCREEN_SRC="kscreen-$KSCREEN_VER"
KSCREENLOCKER_SRC="kscreenlocker-$KSCREENLOCKER_VER"
LAYERSHELLQT_SRC="layer-shell-qt-$LAYERSHELLQT_VER"
PLASMAACTIVITIESSTATS_SRC="plasma-activities-stats-$PLASMAACTIVITIESSTATS_VER"
SQLITE_SRC="sqlite-autoconf-$SQLITE_VER"
QCORO_SRC="qcoro-$QCORO_VER"
ICU_SRC="icu4c-$ICU_VER-sources"
LIBGLVND_SRC="libglvnd-v$LIBGLVND_VER"
LIBKSCREEN_SRC="libkscreen-$LIBKSCREEN_VER"
LIBXI_SRC="libXi-$LIBXI_VER"
UTILMACROS_SRC="util-macros-$UTILMACROS_VER"
LIBXDAMAGE_SRC="libXdamage-$LIBXDAMAGE_VER"
LIBXSHMFENCE_SRC="libxshmfence-$LIBXSHMFENCE_VER"
LIBXXF86VM_SRC="libXxf86vm-$LIBXXF86VM_VER"
MESA_SRC="mesa-$MESA_VER"
LIBEPOXY_SRC="libepoxy-$LIBEPOXY_VER"
KDECORATION_SRC="kdecoration-$KDECORATION_VER"
KGLOBALACCELD_SRC="kglobalacceld-$KGLOBALACCELD_VER"
LIBDISPLAYINFO_SRC="libdisplay-info-$LIBDISPLAYINFO_VER"
QTSPEECH_SRC="qtspeech-everywhere-src-$QTSPEECH_VER"
QTMULTIMEDIA_SRC="qtmultimedia-everywhere-src-$QTMULTIMEDIA_VER"
OPENSSL_SRC="openssl-$OPENSSL_VER"
QTBASE_SRC="qtbase-everywhere-src-$QTBASE_VER"
QTSVG_SRC="qtsvg-everywhere-src-$QTSVG_VER"
QTSHADERTOOLS_SRC="qtshadertools-everywhere-src-$QTSHADERTOOLS_VER"
QTDECLARATIVE_SRC="qtdeclarative-everywhere-src-$QTDECLARATIVE_VER"
XORGPROTO_SRC="xorgproto-$XORGPROTO_VER"
XTRANS_SRC="xtrans-$XTRANS_VER"
ZLIB_SRC="zlib-$ZLIB_VER"
FREETYPE_SRC="freetype-$FREETYPE_VER"
LIBFONTENC_SRC="libfontenc-$LIBFONTENC_VER"
LIBXFONT2_SRC="libXfont2-$LIBXFONT2_VER"
FONTUTIL_SRC="font-util-$FONTUTIL_VER"
LIBXCVT_SRC="libxcvt-$LIBXCVT_VER"
LIBMD_SRC="libmd-$LIBMD_VER"
XCBPROTO_SRC="xcb-proto-$XCBPROTO_VER"
LIBXAU_SRC="libXau-$LIBXAU_VER"
LIBXDMCP_SRC="libXdmcp-$LIBXDMCP_VER"
PIXMAN_SRC="pixman-$PIXMAN_VER"
LIBDRM_SRC="libdrm-$LIBDRM_VER"
LIBPCIACCESS_SRC="libpciaccess-$LIBPCIACCESS_VER"
LIBXCB_SRC="libxcb-$LIBXCB_VER"
LIBX11_SRC="libX11-$LIBX11_VER"
LIBXEXT_SRC="libXext-$LIBXEXT_VER"
LIBXKBFILE_SRC="libxkbfile-$LIBXKBFILE_VER"
XKEYBOARDCONFIG_SRC="xkeyboard-config-$XKEYBOARDCONFIG_VER"
XKBCOMP_SRC="xkbcomp-$XKBCOMP_VER"
XORGSERVER_SRC="xorg-server-$XORGSERVER_VER"
MTDEV_SRC="mtdev-$MTDEV_VER"
LIBEVDEV_SRC="libevdev-$LIBEVDEV_VER"
XF86INPUTEVDEV_SRC="xf86-input-evdev-$XF86INPUTEVDEV_VER"
LIBXINERAMA_SRC="libXinerama-$LIBXINERAMA_VER"
LIBXRENDER_SRC="libXrender-$LIBXRENDER_VER"
LIBXFT_SRC="libXft-$LIBXFT_VER"
FONTCONFIG_SRC="fontconfig-$FONTCONFIG_VER"
LIBICE_SRC="libICE-$LIBICE_VER"
LIBSM_SRC="libSM-$LIBSM_VER"
LIBXT_SRC="libXt-$LIBXT_VER"
LIBXMU_SRC="libXmu-$LIBXMU_VER"
XAUTH_SRC="xauth-$XAUTH_VER"
DEJAVU_SRC="dejavu-fonts-ttf-$DEJAVU_VER"
DWM_SRC="dwm-$DWM_VER"
ST_SRC="st-$ST_VER"
XINIT_SRC="xinit-$XINIT_VER"
LIBFFI_SRC="libffi-$LIBFFI_VER"
WAYLAND_SRC="wayland-$WAYLAND_VER"
WAYLANDPROTOCOLS_SRC="wayland-protocols-$WAYLANDPROTOCOLS_VER"
PLASMAWAYLANDPROTOCOLS_SRC="plasma-wayland-protocols-$PLASMAWAYLANDPROTOCOLS_VER"
QTWAYLAND_SRC="qtwayland-everywhere-src-$QTWAYLAND_VER"
QTTOOLS_SRC="qttools-everywhere-src-$QTTOOLS_VER"
QTSENSORS_SRC="qtsensors-everywhere-src-$QTSENSORS_VER"
KNIGHTTIME_SRC="knighttime-$KNIGHTTIME_VER"
LCMS2_SRC="lcms2-$LCMS2_VER"
QTPOSITIONING_SRC="qtpositioning-everywhere-src-$QTPOSITIONING_VER"
QTLOCATION_SRC="qtlocation-everywhere-src-$QTLOCATION_VER"
KIRIGAMI_SRC="kirigami-$KIRIGAMI_VER"
KIRIGAMIADDONS_SRC="kirigami-addons-$KIRIGAMIADDONS_VER"
PLASMAACTIVITIES_SRC="plasma-activities-$PLASMAACTIVITIES_VER"
LIBPLASMA_SRC="libplasma-$LIBPLASMA_VER"
PLASMAWORKSPACE_SRC="plasma-workspace-$PLASMAWORKSPACE_VER"
KWIN_SRC="kwin-x11-$KWIN_VER"
PLASMADESKTOP_SRC="plasma-desktop-$PLASMADESKTOP_VER"
SYSTEMSETTINGS_SRC="systemsettings-$SYSTEMSETTINGS_VER"
KINFOCENTER_SRC="kinfocenter-$KINFOCENTER_VER"
VULKANHEADERS_SRC="Vulkan-Headers-$VULKANHEADERS_VER"
BREEZE_SRC="breeze-$BREEZE_VER"
KQUICKCHARTS_SRC="kquickcharts-$KQUICKCHARTS_VER"
KPTY_SRC="kpty-$KPTY_VER"
KFILEMETADATA_SRC="kfilemetadata-$KFILEMETADATA_VER"
HARFBUZZ_SRC="harfbuzz-$HARFBUZZ_VER"
CAIRO_SRC="cairo-$CAIRO_VER"
FRIBIDI_SRC="fribidi-$FRIBIDI_VER"
PANGO_SRC="pango-$PANGO_VER"
ATK_SRC="atk-$ATK_VER"
DUKTAPE_SRC="duktape-$DUKTAPE_VER"
POLKIT_SRC="polkit-$POLKIT_VER"
LIBGUDEV_SRC="libgudev-$LIBGUDEV_VER"
UDISKS2_SRC="udisks-$UDISKS2_VER"
SDDM_SRC="sddm-$SDDM_VER"
GDKPIXBUF_SRC="gdk-pixbuf-$GDKPIXBUF_VER"
GTK3_SRC="gtk-$GTK3_VER"
KONSOLE_SRC="konsole-$KONSOLE_VER"
DOLPHIN_SRC="dolphin-$DOLPHIN_VER"
LLVM_SRC="llvm-project-$LLVM_VER.src"
LIBXCOMPOSITE_SRC="libXcomposite-$LIBXCOMPOSITE_VER"
ATSPI2CORE_SRC="at-spi2-core-$ATSPI2CORE_VER"
LIBPNG_SRC="libpng-$LIBPNG_VER"
NSPR_SRC="nspr-$NSPR_VER"
NSS_SRC="nss-$NSS_VER"
ELFUTILS_SRC="elfutils-$ELFUTILS_VER"

export BINUTILS_VER GCC_VER GLIBC_VER LINUX_VER BUSYBOX_VER BASH_VER
export NCURSES_VER LIBXCRYPT_VER UTIL_LINUX_VER LIBCAP_VER ACL_VER ATTR_VER KMOD_VER
export EXPAT_VER PAM_VER DBUS_VER SYSTEMD_VER COREUTILS_VER
export GREP_VER SED_VER GAWK_VER FINDUTILS_VER DIFFUTILS_VER TAR_VER GZIP_VER
export XZ_VER LESS_VER FILE_VER WHICH_VER PATCH_VER
export BINUTILS_SRC GCC_SRC GLIBC_SRC LINUX_SRC BUSYBOX_SRC BASH_SRC
export NCURSES_SRC LIBXCRYPT_SRC UTIL_LINUX_SRC LIBCAP_SRC ACL_SRC ATTR_SRC KMOD_SRC
export EXPAT_SRC PAM_SRC DBUS_SRC SYSTEMD_SRC COREUTILS_SRC
export GREP_SRC SED_SRC GAWK_SRC FINDUTILS_SRC DIFFUTILS_SRC TAR_SRC GZIP_SRC
export XZ_SRC LESS_SRC FILE_SRC WHICH_SRC PATCH_SRC
export SOURCES_LIST

export PKG_CONFIG_LIBDIR="$LFS/usr/lib/pkgconfig:$LFS/usr/share/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$LFS"

export JOBS="${JOBS:-$(nproc)}"
export MAKEFLAGS="-j$JOBS"

export CC=gcc-15
export CXX=g++-15
export CXXFLAGS="${CXXFLAGS:-} -fno-char8_t"

mkdir -p "$SOURCES" "$BUILD" "$LFS" "$OUTPUT"

export LLVM_CONFIG_CROSS="$BUILD/llvm-config-cross"
cat > "$LLVM_CONFIG_CROSS" <<EOF
exec "$LFS/usr/lib/ld-linux-x86-64.so.2" --library-path "$LFS/usr/lib" "$LFS/usr/bin/llvm-config" "\$@"
EOF
chmod +x "$LLVM_CONFIG_CROSS"

export MESON_CROSS="$BUILD/meson-cross.txt"
cat > "$MESON_CROSS" <<EOF
[binaries]
c = '$TARGET-gcc'
cpp = '$TARGET-g++'
ar = '$TARGET-ar'
strip = '$TARGET-strip'
pkg-config = 'pkg-config'
pkgconfig = 'pkg-config'
llvm-config = '$LLVM_CONFIG_CROSS'

[host_machine]
system = 'linux'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'

[properties]
sys_root = '$LFS'
pkg_config_libdir = ['$LFS/usr/lib/pkgconfig', '$LFS/usr/share/pkgconfig']
EOF

export PKG_CONFIG_NATIVE="$BUILD/pkg-config-native"
cat > "$PKG_CONFIG_NATIVE" <<'EOF'
unset PKG_CONFIG_SYSROOT_DIR
export PKG_CONFIG_LIBDIR="/usr/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig"
exec pkg-config "$@"
EOF
chmod +x "$PKG_CONFIG_NATIVE"

export MESON_NATIVE="$BUILD/meson-native.txt"
cat > "$MESON_NATIVE" <<EOF
[binaries]
pkg-config = '$PKG_CONFIG_NATIVE'
pkgconfig = '$PKG_CONFIG_NATIVE'

[properties]
pkg_config_libdir = ['/usr/lib/pkgconfig', '/usr/lib64/pkgconfig', '/usr/share/pkgconfig']
EOF

export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER="$TARGET-gcc"
export RUST_TARGET="x86_64-unknown-linux-gnu"

cat > "$BUILD/qt-toolchain.cmake" <<EOF
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER $TARGET-gcc)
set(CMAKE_CXX_COMPILER $TARGET-g++)
set(CMAKE_SYSROOT $LFS)
set(CMAKE_FIND_ROOT_PATH $LFS)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOF
