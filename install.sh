#!/bin/bash
echo "Instalasi Bytrix Cloud Storage (MinIO + Nginx + SSL + ChatGPT Ready)"
read -p "Masukkan subdomain kamu (contoh: files.bytrix.my.id): " DOMAIN

# Clone repo ini
git clone https://github.com/bytrixcloud/storage-ubuntu.git /tmp/storage-deploy
cd /tmp/storage-deploy

# Jalankan deploy
sudo bash deploy.sh "$DOMAIN"

echo "Selesai! Gunakan perintah: sudo storage-manager"
