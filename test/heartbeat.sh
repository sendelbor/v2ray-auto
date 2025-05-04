#!/bin/bash

# 🔐 تنظیمات رمزنگاری
KEY_HEX="000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f" # 32 بایت کلید
IV_HEX="${KEY_HEX:0:32}" # 16 بایت IV از ابتدای کلید

# 📍 آدرس سرور مقصد
API_URL="https://amxxxx.com/api/calling"

# 🧠 محاسبه توکن
generate_token() {
    IP=$(curl -s https://api.ipify.org)
    DATE=$(date +%F)
    PAYLOAD="${IP}|${DATE}"

    # ایجاد فایل temp برای رمزنگاری
    echo -n "$PAYLOAD" > /tmp/plain.txt
    openssl enc -aes-256-cbc -K "$KEY_HEX" -iv "$IV_HEX" -in /tmp/plain.txt -out /tmp/encrypted.bin -nopad -p

    # base64
    base64 /tmp/encrypted.bin > /tmp/token.b64
    TOKEN=$(cat /tmp/token.b64)
}

# 📡 ارسال درخواست
send_heartbeat() {
    generate_token
    curl -s -X POST "$API_URL" -H "Content-Type: application/json" \
         -d "{\"token\":\"$TOKEN\"}"
}

send_heartbeat
