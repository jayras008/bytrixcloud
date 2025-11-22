# BytrixCloud - Private Cloud Storage (S3-Compatible)  
**Cloud storage pribadi kamu sendiri dalam 3 menit – gratis selamanya!**  
100% cocok buat ChatGPT Actions, backup, sharing file, aplikasi, dll.

![BytrixCloud](https://socialify.git.ci/jayras008/bytrixcloud/image?language=1&name=1&owner=1&pattern=Plus&theme=Auto)

## ✨ Fitur Keren
- S3 Compatible (bisa pakai semua tool S3: AWS SDK, rclone, Cyberduck, dll)
- Upload file sampai 10 GB+
- HTTPS otomatis + auto-renew (Let’s Encrypt)
- Siap pakai ChatGPT Custom Actions (upload, download, delete, list)
- Menu interaktif lengkap (`sudo storage-manager`)
- Generate API key, pre-signed URL, renew SSL, restart, dll
- Hanya buka port 80 & 443 (super aman)
- Support Ubuntu 22.04 / 24.04

## 🚀 Instalasi 1 Klik (Termudah di Dunia)

Buka terminal di server Ubuntu kamu, lalu jalankan:

```bash
curl -fsSL https://raw.githubusercontent.com/jayras008/bytrixcloud/main/install.sh | sudo bash
```

Ketik subdomain kamu saat ditanya, contoh:  
`files.bytrix.my.id`

Selesai! Cloud storage langsung aktif di https://files.bytrix.my.id

## ⚙️ Setelah Instalasi

### 1. Buka Menu Manager (wajib tahu!)
```bash
sudo storage-manager
```

Fitur di dalamnya:
- Restart service
- Generate API Key baru
- Buat / hapus bucket
- Renew SSL
- Generate link download/upload (pre-signed URL)
- Lihat log real-time
- Update otomatis

### 2. Pakai di ChatGPT (Custom GPT Actions)

1. Buka GPT kamu → Configure → Actions → Create new action
2. Paste OpenAPI ini:  
   https://raw.githubusercontent.com/jayras008/bytrixcloud/main/openapi-chatgpt.yaml
3. Authentication → AWS Signature Version 4
4. Isi:
   - Service Name: `s3`
   - Region: `us-east-1` (bebas)
   - Access Key ID & Secret Access Key → ambil dari `sudo storage-manager` → menu 2

Selesai! GPT kamu sekarang bisa upload/download file ke storage pribadi kamu!

## 🔗 Link Penting
- Repo GitHub: https://github.com/jayras008/bytrixcloud
- OpenAPI ChatGPT: https://raw.githubusercontent.com/jayras008/bytrixcloud/main/openapi-chatgpt.yaml
- Demo (contoh): https://files.bytrix.my.id (ganti dengan punya kamu)

## 🆘 Butuh Bantuan?
Hubungi:
- GitHub Issues: https://github.com/jayras008/bytrixcloud/issues
- Owner: @jayras008

## ❤️ Dukung Proyek Ini
Kasih **Star** di repo ini biar makin banyak orang tahu!  
Fork → Deploy → Share → Jadiin punya kamu sendiri!

**BytrixCloud – Storage kamu, aturan kamu, selamanya gratis.**
```
