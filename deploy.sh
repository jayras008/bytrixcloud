#!/bin/bash
set -e
DOMAIN="$1"
[[ -z "$DOMAIN" ]] && echo "Usage: $0 subdomain.example.com" && exit 1

echo "Deploy BytrixCloud ke https://$DOMAIN"

apt update && apt upgrade -y
apt install -y nginx certbot python3-certbot-nginx curl wget ufw mc

# MinIO
wget -qO /usr/local/bin/minio https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x /usr/local/bin/minio

# User & data
useradd -r -s /bin/false minio || true
mkdir -p /data/minio
chown minio:minio /data/minio

# Random credentials
ACCESS_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c20)
SECRET_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c40)

# Config
mkdir -p /etc/bytrixcloud
cat > /etc/bytrixcloud/config <<EOF
DOMAIN="$DOMAIN"
ACCESS_KEY="$ACCESS_KEY"
SECRET_KEY="$SECRET_KEY"
EOF

# systemd service
cat > /etc/systemd/system/minio.service <<EOF
[Unit]
Description=BytrixCloud MinIO
After=network.target

[Service]
User=minio
Group=minio
Environment=MINIO_ROOT_USER=$ACCESS_KEY
Environment=MINIO_ROOT_PASSWORD=$SECRET_KEY
ExecStart=/usr/local/bin/minio server /data/minio --address :9000 --console-address :9001
Restart=always
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now minio

# Nginx
cat > /etc/nginx/sites-available/bytrixcloud <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN;
    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    client_max_body_size 10G;

    location / {
        proxy_pass http://127.0.0.1:9000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
ln -sf /etc/nginx/sites-available/bytrixcloud /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m admin@$DOMAIN --redirect

ufw allow 80,443/tcp
ufw --force enable

# Buat bucket default
sleep 10
mc alias set mycloud https://$DOMAIN $ACCESS_KEY $SECRET_KEY --api S3v4
mc mb mycloud/gpt-storage || true

# Install manager
curl -fsSL https://raw.githubusercontent.com/jayras008/bytrixcloud/main/storage-manager.sh -o /usr/local/bin/storage-manager
chmod +x /usr/local/bin/storage-manager

echo "SELESAI! Cloud storage aktif di https://$DOMAIN"
echo "Access Key: $ACCESS_KEY"
echo "Secret Key: $SECRET_KEY"
echo "Gunakan: sudo storage-manager untuk menu"
