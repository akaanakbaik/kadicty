#!/bin/sh
set -e
echo "Injecting Modern UI Theme..."
TARGET_DIR="/app/public/css"
mkdir -p "$TARGET_DIR"
cp /scripts/styles.css "$TARGET_DIR/modern.css"

VIEW_FILE="/app/resources/views/templates/wrapper.blade.php"
ADMIN_FILE="/app/resources/views/layouts/admin.blade.php"

if [ -f "$VIEW_FILE" ]; then
    if ! grep -q "modern.css" "$VIEW_FILE"; then
        sed -i '/<\/head>/i <link rel="stylesheet" href="/css/modern.css">' "$VIEW_FILE"
        echo "Theme injected into User Panel."
    fi
fi

if [ -f "$ADMIN_FILE" ]; then
    if ! grep -q "modern.css" "$ADMIN_FILE"; then
        sed -i '/<\/head>/i <link rel="stylesheet" href="/css/modern.css">' "$ADMIN_FILE"
        echo "Theme injected into Admin Panel."
    fi
fi
