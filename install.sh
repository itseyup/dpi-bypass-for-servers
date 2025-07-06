#!/bin/bash

# === KULLANICI AYARLARI ===
domain="seninalanadın.com"  # <---- BURAYI KENDİ DOMAIN'İNLE DEĞİŞTİR
uuid=$(cat /proc/sys/kernel/random/uuid)
email="admin@$domain"
ws_path="/ws"

# === GEREKLİ PAKETLER ===
apt update && apt install -y curl wget unzip socat cron bash-completion

# === XRAY İNDİR ===
mkdir -p /etc/xray
wget -O /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /tmp/xray.zip -d /usr/local/bin/
chmod +x /usr/local/bin/xray

# === ACME.SH İLE SSL AL ===
apt install -y socat
curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --issue -d $domain --standalone --keylength ec-256 --force
~/.acme.sh/acme.sh --install-cert -d $domain --ecc \
  --key-file /etc/xray/xray.key \
  --fullchain-file /etc/xray/xray.crt

# === XRAY CONFIG OLUŞTUR ===
cat <<EOF > /etc/xray/config.json
{
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$uuid",
            "level": 0,
            "email": "$email"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/xray.crt",
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        },
        "wsSettings": {
          "path": "$ws_path"
        }
      }
    },
    {
      "port": 10808,
      "listen": "127.0.0.1",
      "protocol": "socks",
      "settings": {
        "auth": "noauth"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF

# === XRAY SERVİSİ ===
cat <<EOF > /etc/systemd/system/xray.service
[Unit]
Description=Xray Service
After=network.target

[Service]
ExecStart=/usr/local/bin/xray -config /etc/xray/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable xray
systemctl restart xray

clear
echo -e "\n✅ Xray kurulumu tamamlandı!"
echo -e "Alan adı: $domain"
echo -e "UUID: $uuid"
echo -e "WebSocket Path: $ws_path"
echo -e "Port: 443 (TLS)"
echo -e "SOCKS5 Proxy Port: 10808 (localhost, no auth)"
