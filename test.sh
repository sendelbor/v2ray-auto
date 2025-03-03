#!/bin/bash

# پارامترهای خط فرمان
while [[ $# -gt 0 ]]; do
    case "$1" in
        --port)
            PORT="$2"
            shift 2
            ;;
        --username)
            USERNAME="$2"
            shift 2
            ;;
        --password)
            PASSWORD="$2"
            shift 2
            ;;
        --webBasePath)
            WEB_BASE_PATH="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# مرحله 1: نصب و تنظیمات 3x-ui
echo "install 3x-ui"
bash <(curl -Ls https://raw.githubusercontent.com/sendelbor/v2ray-auto/refs/heads/main/auto.sh) --port "$PORT" --username "$USERNAME" --password "$PASSWORD" --webBasePath "$WEB_BASE_PATH"

# مرحله 2: تنظیمات iptables
echo "set iptables configuration"
iptables -A OUTPUT -o eth0 -d 0.0.0.0/8 -j DROP
iptables -A OUTPUT -o eth0 -d 10.0.0.0/8 -j DROP
iptables -A OUTPUT -o eth0 -d 100.64.0.0/10 -j DROP
iptables -A OUTPUT -o eth0 -d 127.0.0.0/8 -j DROP
iptables -A OUTPUT -o eth0 -d 169.254.0.0/16 -j DROP
iptables -A OUTPUT -o eth0 -d 172.16.0.0/12 -j DROP
iptables -A OUTPUT -o eth0 -d 192.0.2.0/24 -j DROP
iptables -A OUTPUT -o eth0 -d 192.168.0.0/16 -j DROP
iptables -A OUTPUT -o eth0 -d 198.18.0.0/15 -j DROP
iptables -A OUTPUT -o eth0 -d 224.0.0.0/4 -j DROP
iptables -A OUTPUT -o eth0 -d 240.0.0.0/4 -j DROP
iptables -A OUTPUT -o eth0 -d 203.0.113.0/24 -j DROP
iptables -A OUTPUT -o eth0 -d 224.0.0.0/3 -j DROP
iptables -A OUTPUT -o eth0 -d 198.51.100.0/24 -j DROP
iptables -A OUTPUT -o eth0 -d 192.88.99.0/24 -j DROP
iptables -A OUTPUT -o eth0 -d 192.0.0.0/24 -j DROP
iptables -A OUTPUT -o eth0 -d 223.202.0.0/16 -j DROP
iptables -A OUTPUT -o eth0 -d 194.5.192.0/19 -j DROP
iptables -A OUTPUT -o eth0 -d 209.237.192.0/18 -j DROP
iptables -A OUTPUT -o eth0 -d 169.254.0.0/16 -j DROP
iptables -A OUTPUT -d 102.0.0.0/8 -j DROP

echo "install iptables-persistent"
apt-get update
apt-get install -y iptables-persistent

echo "save setting for iptables"
netfilter-persistent save

echo "block torent"
wget https://github.com/Heclalava/blockpublictorrent-iptables/raw/main/bt.sh && chmod +x bt.sh && bash bt.sh

echo "set ssl path Public Key and Private Key"
/usr/local/x-ui/x-ui setting -publicKeyPath "/root/cert.crt" -privateKeyPath "/root/private.key"

echo "complete !"
