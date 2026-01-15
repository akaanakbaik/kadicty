#!/bin/bash
set -e
mkdir -p wings
touch wings/config.yml
read -p "Masukkan URL Panel (default: http://localhost): " INPUT_URL
APP_URL=${INPUT_URL:-http://localhost}
read -p "Masukkan Timezone (default: Asia/Jakarta): " INPUT_TZ
APP_TIMEZONE=${INPUT_TZ:-Asia/Jakarta}
read -p "Masukkan Email Admin: " ADMIN_EMAIL
read -p "Masukkan Password Database Baru: " DB_PASSWORD
cat > .env <<EOF
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:$(openssl rand -base64 32)
APP_URL=$APP_URL
APP_TIMEZONE=$APP_TIMEZONE
APP_LOCALE=id
LOG_CHANNEL=daily
DB_CONNECTION=pgsql
DB_HOST=database
DB_PORT=5432
DB_DATABASE=panel
DB_USERNAME=pterodactyl
DB_PASSWORD=$DB_PASSWORD
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
REDIS_HOST=cache
REDIS_PASSWORD=null
REDIS_PORT=6379
MAIL_MAILER=smtp
MAIL_HOST=smtp.example.com
MAIL_PORT=587
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@example.com
MAIL_FROM_NAME=Pterodactyl
HASHIDS_SALT=$(openssl rand -hex 8)
HASHIDS_LENGTH=8
EOF
docker-compose up -d database cache
echo "Menunggu database siap (10 detik)..."
sleep 10
docker-compose run --rm panel php artisan migrate --seed --force
docker-compose run --rm panel php artisan p:user:make --email=$ADMIN_EMAIL --admin=1
docker-compose up -d
echo "Instalasi Panel Selesai."
echo "Lanjut ke konfigurasi Node/Wings di browser, lalu edit file wings/config.yml"
