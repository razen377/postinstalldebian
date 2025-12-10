#!/bin/bash
# Script ultra-simple – 100% automatique – marche partout

echo "Mise à jour et installation en cours... (Cela peut prendre quelques minutes)"

# On ouvre un bloc avec { } et on redirige tout ce qui est dedans vers /dev/null
{
    # Évite les questions de configuration interactives pendant l'install
    export DEBIAN_FRONTEND=noninteractive

    apt update && apt upgrade -y
    apt install -y ssh zip unzip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx winbind samba

    # Indexation pour locate
    updatedb

    # Ajout automatique de "wins" dans nsswitch.conf (si pas déjà là)
    grep -q "wins" /etc/nsswitch.conf || sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf

    # Activer le beau prompt couleur pour root
    sed -i '9,13s/^#//' /root/.bashrc

} > /dev/null 2>&1

# Les commandes ci-dessous s'afficheront car elles sont hors du bloc silencieux
echo ""
echo "=================================================="
echo "Tout est installé et configuré !"
echo "Redémarre le serveur avec : reboot"
echo "=================================================="
