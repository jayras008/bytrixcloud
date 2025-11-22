#!/bin/bash
# BytrixCloud Storage Manager
CONFIG="/etc/bytrixcloud/config"
[[ -f "$CONFIG" ]] && source "$CONFIG" || { echo "Config tidak ditemukan!"; exit 1; }

GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
mc alias set mycloud https://$DOMAIN $ACCESS_KEY $SECRET_KEY --api S3v4 &>/dev/null || true

while true; do
clear
echo "=================================="
echo "   BYTRIXCLOUD MANAGER"
echo "   https://$DOMAIN"
echo "=================================="
echo "1. Restart MinIO + Nginx"
echo "2. Generate API Key baru"
echo "3. Buat bucket baru"
echo "4. List bucket"
echo "5. List API keys"
echo "6. Renew SSL"
echo "7. Log real-time"
echo "8. Generate link download/upload"
echo "9. Update manager"
echo "0. Keluar"
echo "=================================="
read -p "Pilih: " pil

case $pil in
1) systemctl restart minio nginx; echo -e "${GREEN}Restart selesai${NC}";;
2) NEW_ACCESS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c20)
   NEW_SECRET=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c40)
   mc admin user add mycloud $NEW_ACCESS $NEW_SECRET
   echo "Access Key: $NEW_ACCESS"
   echo "Secret Key: $NEW_SECRET";;
3) read -p "Nama bucket: " b; mc mb mycloud/$b && echo -e "${GREEN}Bucket $b dibuat${NC}";;
4) mc ls mycloud;;
5) mc admin user list mycloud;;
6) certbot renew --quiet && systemctl reload nginx && echo -e "${GREEN}SSL diperbarui${NC}";;
7) journalctl -u minio -f;;
8) read -p "Bucket: " bk; read -p "File: " fl; read -p "Expire (7d/1h): " ex
   echo "Download:"; mc share download mycloud/$bk/$fl --expire $ex
   echo "Upload:"; mc share upload mycloud/$bk/$fl --expire $ex;;
9) curl -fsSL https://raw.githubusercontent.com/jayras008/bytrixcloud/main/storage-manager.sh -o /usr/local/bin/storage-manager
   chmod +x /usr/local/bin/storage-manager
   echo -e "${GREEN}Manager diperbarui${NC}";;
0) exit;;
esac
read -p "Enter untuk lanjut..."
done
