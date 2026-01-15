#!/bin/sh
set -e
DOMAIN=$(echo $APP_URL | awk -F/ '{print $3}')
EMAIL=${APP_SERVICE_AUTHOR:-admin@example.com}

if [ "$APP_URL" != "http://localhost" ] && [ ! -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
    echo "Starting Auto-SSL for $DOMAIN..."
    certbot --nginx \
        --non-interactive \
        --agree-tos \
        --email $EMAIL \
        --domains $DOMAIN
    echo "SSL Certificate installed."
else
    echo "Skipping SSL setup (Localhost or Certificate exists)."
fi
