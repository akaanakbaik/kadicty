#!/bin/sh
set -e
/scripts/core.sh
/scripts/patch_ui.sh
mkdir -p /app/storage/logs
chown -R www-data:www-data /app/storage /app/bootstrap/cache
if [ ! -f /etc/nginx/http.d/panel.conf ]; then
    cat > /etc/nginx/http.d/panel.conf <<EOF
server {
    listen 80;
    server_name _;
    root /app/public;
    index index.html index.htm index.php;
    charset utf-8;
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }
    access_log off;
    error_log  /var/log/nginx/panel.app-error.log error;
    client_max_body_size 100m;
    client_body_timeout 120s;
    sendfile off;
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }
    location ~ /\.ht {
        deny all;
    }
}
EOF
fi
/scripts/ssl.sh
if [ -f "artisan" ]; then
    php artisan migrate --force
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
fi
/usr/bin/supervisord -c /etc/supervisord.conf &
php-fpm -D
nginx -g "daemon off;"
