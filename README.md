# Universal Orchestrator Panel

## Instalasi
1. Berikan izin eksekusi:
   chmod +x setup.sh update.sh reset.sh tools/*.sh
2. Jalankan installer:
   ./setup.sh

## Fitur Utama
- **Auto-Install:** Panel & Wings terinstall dan terhubung otomatis.
- **Universal Egg:** Bisa menjalankan image Docker apa saja (Python, Node, Go, Java) tanpa config ribet.
- **Modern UI:** Glassmorphism theme + Terminal Copy-Paste fix.
- **Auto SSL:** HTTPS otomatis via Let's Encrypt.
- **Privileged Mode:** Mendukung VPN dan Docker-in-Docker.

## Cara Menggunakan Universal Egg
1. Buat Server baru di Admin Panel.
2. Pilih Nest: "Universal Runner".
3. Pilih Egg: "Generic Docker".
4. Di kolom "Docker Image", ketik image yang diinginkan.
   Contoh:
   - python:3.11-slim
   - node:18-alpine
   - openjdk:17-slim
   - ubuntu:22.04
5. Panel akan otomatis mendeteksi bahasa dan menjalankan startup command.

## Login Default
- **Email:** (Sesuai input saat setup)
- **Password:** (Sesuai input saat setup)

## Lokasi File
- Data Panel: /var/lib/docker/volumes/project_panel_data
- Data Wings: /var/lib/pterodactyl
- Config Wings: ./wings/config.yml
