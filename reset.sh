#!/bin/bash
read -p "INI AKAN MENGHAPUS SEMUA DATA. YAKIN? (y/n): " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    docker-compose down -v
    rm -f .env
    rm -f wings/config.yml
    sudo rm -rf panel/src
    docker rmi $(docker images -q panel_panel) 2>/dev/null
    echo "Sistem telah di-reset ke pengaturan pabrik."
else
    echo "Dibatalkan."
fi
