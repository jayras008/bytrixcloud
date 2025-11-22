#!/bin/bash
set -e
DOMAIN="$1"
if [ -z "$DOMAIN" ]; then echo "Usage: $0 subdomain.example.com"; exit 1; fi

echo "Deploy Cloud Storage ke $DOMAIN"

# Install dependencies
apt update && apt upgrade -y
apt install -y nginx certbot python3-certbot-nginx curl wget ufw git mc

# MinIO binary
wget -q https://dl.min.io/server/minio/release/linux-amd64/minio -O /usr/local/bin/minio
chmod +x /usr/local/bin/minio

# Data directory + permission aman
mkdir -p /data/minio
chown -R minio:minio /data/minio 2>/dev/null || useradd -r -s /bin/false minio

# Generate kredensial kuat
ACCESS_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c20)
SECRET_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c40)

# Simpan config
cat > /etc/bytrix-storage.conf <<EOF
DOMAIN="$DOMAIN"
ACCESS_KEY="$ACCESS_KEY"
SECRET_KEY="$SECRET_KEY"
BUCKET="gpt-storage"
EOF

# systemd service (port 9000 & 9001, user minio)
install -m 644 systemd/minio.service /etc/systemd/system/minio.service
sed -i "s|ACCESS_KEY|$ACCESS_KEY|g" /etc/systemd/system/minio.service
sed -i "s|SECRET_KEY|$SECRET_KEY|g" /etc/systemd/system/minio.service
systemctl daemon-reload
systemctl enable --now minio

# Nginx config
mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
cp nginx/sites-available/storage /etc/nginx/sites-available/storage
sed -i "s/DOMAIN_PLACEHOLDER/$DOMAIN/g" /etc/nginx/sites-available/storage
ln -sf /etc/nginx/sites-available/storage /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# SSL
certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m admin@$DOMAIN

# Buka port aman
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Buat bucket default
sleep 10
mc alias set mycloud https://$DOMAIN $ACCESS_KEY $SECRET_KEY --api S3v4
mc mb mycloud/gpt-storage || true

# Install storage-manager
cp storage-manager.sh /usr/local/bin/storage-manager
chmod +x /usr/local/bin/storage-manager

echo "SELESAI! https://$DOMAIN siap pakai"
echo "Access Key: $ACCESS_KEY"
echo "Secret Key: $SECRET_KEY"
