#!/bin/bash

SERVERS=(
    "http://google.com"
    "http://cloudflare.com"
    "http://1.1.1.1"
)

while true; do
    for SERVER in "${SERVERS[@]}"; do
        DATE_STR=$(curl -sI --connect-timeout 5 "$SERVER" | grep -i '^date:' | sed 's/^[Dd]ate: //I' | tr -d '\r')

        if [ -n "$DATE_STR" ]; then
            date -s "$DATE_STR"
            hwclock --systohc
            echo "Time synced from $SERVER to: $DATE_STR"
            exit 0
        fi
    done

    # All servers failed; wait 60 seconds before retrying
    sleep 60
done
