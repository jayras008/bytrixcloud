#!/bin/bash
clear
echo "=========================================="
echo "   BYTRIXCLOUD - Self-Hosted Cloud Storage"
echo "   1-Klik Install untuk Ubuntu 22.04/24.04"
echo "=========================================="
echo ""
read -p "Masukkan subdomain kamu (contoh: files.bytrix.my.id): " DOMAIN

if [[ -z "$DOMAIN" ]]; then
  echo "Subdomain tidak boleh kosong!"
  exit 1
fi

echo "Memulai instalasi otomatis untuk $DOMAIN ..."
curl -fsSL https://raw.githubusercontent.com/jayras008/bytrixcloud/main/deploy.sh | sudo bash -s -- "$DOMAIN"
