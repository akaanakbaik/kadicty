#!/bin/bash
set -e
echo "Memulai proses update sistem..."
docker-compose down
docker-compose pull database cache wings
docker-compose build --no-cache panel
docker-compose up -d
echo "Membersihkan cache aplikasi..."
docker-compose run --rm panel php artisan view:clear
docker-compose run --rm panel php artisan config:clear
docker-compose run --rm panel php artisan route:clear
echo "Update Selesai."
