#!/bin/sh
set -e
if [ -z "$(ls -A /app)" ]; then
    echo "Downloading Pterodactyl Core..."
    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv -C /app
    chmod -R 755 /app/storage /app/bootstrap/cache
    cp .env.example .env
    composer install --no-dev --optimize-autoloader
else
    echo "Core files exist, checking permissions..."
    chmod -R 755 /app/storage /app/bootstrap/cache
fi
chown -R www-data:www-data /app
