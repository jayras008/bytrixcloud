#!/bin/bash
# BytrixCloud - 1-Klik Installer (Fix 100% Interactive)
# Repo: https://github.com/jayras008/bytrixcloud

# Force terminal jadi interactive supaya read -p pasti muncul
if [[ -t 0 ]] && [[ -t 1 ]]; then
    :
else
    exec </dev/tty >/dev/tty 2>/dev/tty
fi

clear
echo "=========================================="
echo "   BYTRIXCLOUD - Self-Hosted Cloud Storage"
echo "   1-Klik Install untuk Ubuntu 22.04/24.04"
echo "=========================================="
echo

# Prioritas 1: kalau ada argumen dari command line
if [[ -n "$1" ]]; then
    DOMAIN="$1"
    echo "✓ Subdomain dari argumen: $DOMAIN"
else
    # Prioritas 2: tanya manual (pasti muncul!)
    while [[ -z "$DOMAIN" ]]; do
        read -p "Masukkan subdomain kamu (contoh: files.bytrix.my.id): " DOMAIN
        [[ -z "$DOMAIN" ]] && echo "Subdomain tidak boleh kosong! Coba lagi."
    done
    echo "✓ Subdomain diterima: $DOMAIN"
fi

echo
echo "Memulai instalasi otomatis..."
echo "Tunggu 1-3 menit ya..."
echo

# Jalankan deploy dengan domain yang sudah pasti ada
curl -fsSL https://raw.githubusercontent.com/jayras008/bytrixcloud/main/deploy.sh | sudo bash -s -- "$DOMAIN"
