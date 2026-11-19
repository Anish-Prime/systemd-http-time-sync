#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (e.g., sudo ./uninstall.sh)"
    exit 1
fi

echo "Uninstalling http-time-sync..."
systemctl disable --now http-time-sync.service 2>/dev/null || true
rm -f /etc/systemd/system/http-time-sync.service
rm -f /usr/local/bin/http-time-sync.sh
systemctl daemon-reload

echo "Uninstalled cleanly."
