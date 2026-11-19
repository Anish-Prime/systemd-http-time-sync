#!/bin/bash
set -e

REPO_RAW="https://raw.githubusercontent.com/Anish-Prime/systemd-http-time-sync/main"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (e.g., sudo ./install.sh)"
    exit 1
fi

echo "Installing http-time-sync..."

if [ -f "http-time-sync.sh" ] && [ -f "http-time-sync.service" ]; then
    cp http-time-sync.sh /usr/local/bin/http-time-sync.sh
    cp http-time-sync.service /etc/systemd/system/http-time-sync.service
else
    curl -fsSL "$REPO_RAW/http-time-sync.sh" -o /usr/local/bin/http-time-sync.sh
    curl -fsSL "$REPO_RAW/http-time-sync.service" -o /etc/systemd/system/http-time-sync.service
fi

chmod +x /usr/local/bin/http-time-sync.sh
systemctl daemon-reload
systemctl enable --now http-time-sync.service

echo "Done! Check status with: journalctl -u http-time-sync.service -n 5"
