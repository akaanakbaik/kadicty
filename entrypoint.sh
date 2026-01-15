#!/bin/bash
set -e
echo "Mengoptimalkan Kernel untuk Container..."
sysctl -w vm.swappiness=10
sysctl -w net.core.default_qdisc=fq
sysctl -w net.ipv4.tcp_congestion_control=bbr
echo "Melakukan Pre-Pull Image Populer (Supaya user tidak menunggu lama)..."
docker pull ghcr.io/pterodactyl/yolks:java_17
docker pull ghcr.io/pterodactyl/yolks:python_3.11
docker pull ghcr.io/pterodactyl/yolks:nodejs_18
docker pull ghcr.io/pterodactyl/yolks:go_1.20
docker pull ubuntu:22.04
docker pull alpine:latest
echo "Optimasi Selesai."
