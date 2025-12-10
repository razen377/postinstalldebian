#!/bin/bash

    apt update && apt upgrade -y
    apt install -y ssh zip unzip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx winbind samba

    # Indexation pour locate
    updatedb

    # Ajout automatique de "wins" 
    grep -q "wins" /etc/nsswitch.conf || sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf

    sed -i '9,13s/^#//' /root/.bashrc

# Les commandes ci-dessous s'afficheront car elles sont hors du bloc silencieux
echo ""
echo "=================================================="
echo "Tout est installé et configuré !"
echo "Redémarre le serveur avec : reboot"
echo "=================================================="
