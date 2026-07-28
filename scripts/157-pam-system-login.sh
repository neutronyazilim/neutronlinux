#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source config.sh

STAMPS="$BUILD/.stamps"
mkdir -p "$STAMPS"
[ -f "$STAMPS/pam-system-login" ] && { echo "system-login/system-auth zaten var, atlaniyor"; exit 0; }

cat > "$LFS/etc/pam.d/system-auth" <<'EOF'
auth        optional    pam_env.so
auth        required    pam_unix.so
account     required    pam_unix.so
password    required    pam_unix.so
session     required    pam_unix.so
EOF

cat > "$LFS/etc/pam.d/system-login" <<'EOF'
auth        include     system-auth
account     include     system-auth
password    include     system-auth
session     include     system-auth
session     optional    pam_systemd.so
EOF

touch "$STAMPS/pam-system-login"
echo "system-auth/system-login olusturuldu"
