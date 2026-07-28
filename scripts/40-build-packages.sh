#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

REPO="$OUTPUT/repo"
mkdir -p "$REPO"
STAGING_ROOT="$BUILD/pkg-staging"

PACKAGES="
busybox|$BUSYBOX_VER|$BUILD/$BUSYBOX_SRC|busybox
bash|$BASH_VER|$BUILD/$BASH_SRC|make
coreutils|$COREUTILS_VER|$BUILD/$COREUTILS_SRC|make
grep|$GREP_VER|$BUILD/$GREP_SRC|make
sed|$SED_VER|$BUILD/$SED_SRC|make
gawk|$GAWK_VER|$BUILD/$GAWK_SRC|make
findutils|$FINDUTILS_VER|$BUILD/$FINDUTILS_SRC|make
diffutils|$DIFFUTILS_VER|$BUILD/$DIFFUTILS_SRC|make
tar|$TAR_VER|$BUILD/$TAR_SRC|make
gzip|$GZIP_VER|$BUILD/$GZIP_SRC|make
xz|$XZ_VER|$BUILD/$XZ_SRC|make
less|$LESS_VER|$BUILD/$LESS_SRC|make
file|$FILE_VER|$BUILD/$FILE_SRC|make-file
which|$WHICH_VER|$BUILD/$WHICH_SRC|make
patch|$PATCH_VER|$BUILD/$PATCH_SRC|make
ncurses|$NCURSES_VER|$BUILD/$NCURSES_SRC|make
libxcrypt|$LIBXCRYPT_VER|$BUILD/$LIBXCRYPT_SRC|make
libcap|$LIBCAP_VER|$BUILD/$LIBCAP_SRC|libcap
acl|$ACL_VER|$BUILD/$ACL_SRC|make
attr|$ATTR_VER|$BUILD/$ATTR_SRC|make
kmod|$KMOD_VER|$BUILD/$KMOD_SRC|make
expat|$EXPAT_VER|$BUILD/$EXPAT_SRC|make
pam|$PAM_VER|$BUILD/$PAM_SRC|make
dbus|$DBUS_VER|$BUILD/$DBUS_SRC|make
util-linux|$UTIL_LINUX_VER|$BUILD/$UTIL_LINUX_SRC|meson
systemd|$SYSTEMD_VER|$BUILD/$SYSTEMD_SRC|meson
fastfetch|2.66.0|$BUILD/fastfetch-2.66.0|cmake
"

echo "name,version,file" > "$REPO/.index.tmp"

echo "$PACKAGES" | while IFS='|' read -r name version builddir buildsystem; do
    [ -z "$name" ] && continue
    [ -d "$builddir" ] || { echo "atlaniyor (build dir yok): $name" >&2; continue; }

    staging="$STAGING_ROOT/$name"
    rm -rf "$staging"
    mkdir -p "$staging"

    case "$buildsystem" in
        make)
            make -C "$builddir" DESTDIR="$staging" install >/dev/null
            ;;
        make-file)
            make -C "$builddir" DESTDIR="$staging" install \
                FILE_COMPILE="$builddir/native-build/src/file" >/dev/null
            ;;
        busybox)
            make -C "$builddir" CONFIG_PREFIX="$staging" install >/dev/null
            ;;
        libcap)
            make -C "$builddir" DESTDIR="$staging" prefix=/usr lib=lib install >/dev/null
            ;;
        meson|cmake)
            DESTDIR="$staging" ninja -C "$builddir/build" install >/dev/null
            ;;
        *)
            echo "bilinmeyen build sistemi: $buildsystem ($name)" >&2
            continue
            ;;
    esac

    PKGFILE="$name-$version.tar.xz"
    (cd "$staging" && tar -cJf "$REPO/$PKGFILE" .)
    cat > "$REPO/$name-$version.info" <<EOF
Name: $name
Version: $version
File: $PKGFILE
EOF
    echo "$name,$version,$PKGFILE" >> "$REPO/.index.tmp"
    echo "paketlendi: $name-$version ($(du -h "$REPO/$PKGFILE" | cut -f1))"
done

mv "$REPO/.index.tmp" "$REPO/index.csv"
echo "Repo hazir: $REPO"
ls "$REPO" | wc -l
