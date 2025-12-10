#!/bin/bash

# Fonction pour afficher la barre de progression
# Utilisation : progress_bar <pourcentage> <message>
progress_bar() {
    local duration=${1}
    local message=${2}
    local columns=$(tput cols)
    local bar_size=$((columns - 20)) # Taille de la barre
    local done=$((duration * bar_size / 100))
    local todo=$((bar_size - done))
    
    # Construction de la barre [###...]
    local bar_done=$(printf "%0.s#" $(seq 1 $done))
    local bar_todo=$(printf "%0.s." $(seq 1 $todo))
    
    # Affichage sur la même ligne (\r)
    echo -ne "\r[$bar_done$bar_todo] $duration% - $message"
}

# Nettoie l'écran pour commencer proprement
clear
echo "Démarrage de la maintenance automatique..."
echo ""

# Configuration non-interactive globale
export DEBIAN_FRONTEND=noninteractive

# ÉTAPE 1 : Mise à jour des listes (10%)
progress_bar 10 "Mise à jour APT"
apt update > /dev/null 2>&1

# ÉTAPE 2 : Upgrade du système (30%)
progress_bar 30 "Upgrade du système"
apt upgrade -y > /dev/null 2>&1

# ÉTAPE 3 : Installation des paquets (60%)
# C'est l'étape la plus longue, on laisse un peu de marge
progress_bar 60 "Installation des paquets"
apt install -y ssh zip unzip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx winbind samba > /dev/null 2>&1

# ÉTAPE 4 : Indexation et config (80%)
progress_bar 80 "Configuration systeme"
updatedb > /dev/null 2>&1

# Ajout automatique de "wins" dans nsswitch.conf
grep -q "wins" /etc/nsswitch.conf || sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf

# ÉTAPE 5 : Configuration du prompt (90%)
progress_bar 90 "Activation couleur root"
sed -i '9,13s/^#//' /root/.bashrc

# FIN (100%)
progress_bar 100 "Terminé !"
echo "" # Saut de ligne final pour ne pas écraser la barre

echo ""
echo "=================================================="
echo "Tout est installé et configuré !"
echo "Redémarre le serveur avec : reboot"
echo "=================================================="
