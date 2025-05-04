#!/bin/bash

CRON_FILE="/etc/cron.d/v2ray-heartbeat"

case "$1" in
  enable)
    echo "*/3 * * * * root bash /usr/local/bin/heartbeat.sh >/dev/null 2>&1" > "$CRON_FILE"
    chmod 644 "$CRON_FILE"
    echo "✅ Heartbeat فعال شد."
    ;;

  disable)
    rm -f "$CRON_FILE"
    echo "⛔️ Heartbeat غیرفعال شد."
    ;;

  status)
    if [ -f "$CRON_FILE" ]; then
        echo "✅ Heartbeat فعال است."
    else
        echo "⛔️ Heartbeat غیرفعال است."
    fi
    ;;

  *)
    echo "Usage: $0 {enable|disable|status}"
    ;;
esac
