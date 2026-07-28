#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/polkit" ] && { echo "polkit zaten derlenmis, atlaniyor"; exit 0; }
for dep in duktape glib expat pam systemd; do
    [ -f "$STAMPS/$dep" ] || { echo "once $dep icin ilgili scripti calistirin" >&2; exit 1; }
done

[ -d "$BUILD/$POLKIT_SRC" ] || tar -xf "$SOURCES/$POLKIT_SRC.tar.bz2" -C "$BUILD"
cd "$BUILD/$POLKIT_SRC"

cat > src/polkitbackend/time64_shim.c <<'EOF'
extern int pthread_cond_timedwait(void *cond, void *mutex, const void *abstime);

int __pthread_cond_timedwait64(void *cond, void *mutex, const void *abstime);

int __pthread_cond_timedwait64(void *cond, void *mutex, const void *abstime)
{
    return pthread_cond_timedwait(cond, mutex, abstime);
}
EOF
grep -q "'time64_shim.c'," src/polkitbackend/meson.build || \
    sed -i "s|  program + '.c',|  program + '.c',\n  'time64_shim.c',|" src/polkitbackend/meson.build

rm -rf build
meson setup build --cross-file="$MESON_CROSS" --native-file="$MESON_NATIVE" --prefix=/usr -Dbuildtype=release \
    -Dsession_tracking=libsystemd-login -Dauthfw=pam -Djs_engine=duktape \
    -Dintrospection=false -Dexamples=false -Dtests=false -Dgtk_doc=false -Dman=false
ninja -C build
DESTDIR="$LFS" ninja -C build install

touch "$STAMPS/polkit"
echo "polkit hazir"
