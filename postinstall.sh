#!/bin/bash
# Script ultra-simple – 100% automatique – marche partout

apt update && apt upgrade -y

apt install -y ssh zip unzip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx winbind samba

# Indexation pour locate
updatedb

# Ajout automatique de "wins" dans nsswitch.conf (si pas déjà là)
grep -q "wins" /etc/nsswitch.conf || sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf

# Activer le beau prompt couleur pour root
sed -i '9,13s/^#//' /root/.bashrc

echo ""
echo "=================================================="
echo "Tout est installé et configuré !"
echo "Redémarre le serveur avec : reboot"
echo "=================================================="
