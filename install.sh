#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (e.g., sudo ./install.sh)"
    exit 1
fi

echo "Installing http-time-sync..."
cp http-time-sync.sh /usr/local/bin/http-time-sync.sh
chmod +x /usr/local/bin/http-time-sync.sh

cp http-time-sync.service /etc/systemd/system/http-time-sync.service
systemctl daemon-reload
systemctl enable --now http-time-sync.service

echo "Done! Check status with: journalctl -u http-time-sync.service -n 5"
