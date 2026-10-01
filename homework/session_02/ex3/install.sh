#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WEB_ROOT="/var/www/ptit-web/html"
AVAILABLE_CONFIG="/etc/nginx/sites-available/ptit-web.conf"
ENABLED_CONFIG="/etc/nginx/sites-enabled/ptit-web.conf"

if [[ "${EUID}" -ne 0 ]]; then
    echo "Vui lòng chạy bằng sudo: sudo ./install.sh" >&2
    exit 1
fi

apt update
apt install -y nginx

install -d -m 0755 "$WEB_ROOT"
install -m 0644 "$SCRIPT_DIR/index.html" "$WEB_ROOT/index.html"
install -m 0644 "$SCRIPT_DIR/ptit-web.conf" "$AVAILABLE_CONFIG"

ln -sfn "$AVAILABLE_CONFIG" "$ENABLED_CONFIG"
unlink /etc/nginx/sites-enabled/default 2>/dev/null || true

nginx -t
systemctl enable --now nginx
systemctl reload nginx

echo "Cài đặt hoàn tất. Truy cập http://<IP_ADDRESS_DROPLET>"
