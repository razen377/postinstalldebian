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
echo "Démarrage de la maintenance et de l'installation automatique..."
echo ""

# Configuration non-interactive globale
export DEBIAN_FRONTEND=noninteractive

# --- ÉTAPES DE MAINTENANCE ET D'INSTALLATION ---

# ÉTAPE 1 : Mise à jour des listes (5%)
progress_bar 5 "Mise à jour APT"
apt update > /dev/null 2>&1

# ÉTAPE 2 : Upgrade du système (15%)
progress_bar 15 "Upgrade du système"
apt upgrade -y > /dev/null 2>&1

# ÉTAPE 3 : Installation des paquets essentiels (45%)
progress_bar 45 "Installation des paquets essentiels"
apt install -y ssh zip unzip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx winbind samba > /dev/null 2>&1

# ÉTAPE 4 : Installation de Webmin (70%)
progress_bar 70 "Installation et configuration du dépôt Webmin"
# Téléchargement du script de configuration de dépôt
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh > /dev/null 2>&1

# Utilisation de 'yes |' pour simuler la touche Entrée/confirmation
progress_bar 72 "Exécution du script de dépôt Webmin"
yes | sh webmin-setup-repo.sh > /dev/null 2>&1

# Mise à jour des listes pour inclure le nouveau dépôt
apt update > /dev/null 2>&1
# Installation de Webmin
progress_bar 75 "Installation de Webmin"
apt install webmin --install-recommends -y > /dev/null 2>&1

# ÉTAPE 5 : Indexation et config système (85%)
progress_bar 85 "Configuration système"
updatedb > /dev/null 2>&1

# Ajout automatique de "wins" dans nsswitch.conf (si absent)
grep -q "wins" /etc/nsswitch.conf || sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf

# ÉTAPE 6 : Configuration du prompt (90%)
progress_bar 90 "Activation couleur root"
# Retire les commentaires des lignes 9 à 13 du .bashrc de root
sed -i '9,13s/^#//' /root/.bashrc

# ÉTAPE 7 : Bonus Fun (95%)
progress_bar 95 "Installation des bsdgames"
apt install bsdgames -y > /dev/null 2>&1

# FIN (100%)
progress_bar 100 "Terminé !"
echo "" # Saut de ligne final pour ne pas écraser la barre

# Nettoyage du fichier temporaire
rm -f webmin-setup-repo.sh

# --- AFFICHAGE FINAL ---
SERVER_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "=================================================="
echo "✅ Installation et configuration terminées !"
echo "=================================================="
echo ""
echo "🌐 **Webmin est accessible via :**"
echo "   -> **https://${SERVER_IP}:10000**"
echo "   (Connectez-vous avec l'utilisateur root ou un utilisateur sudo)"
echo ""
echo "👾 **Bonus Fun (bsdgames) :**"
echo "   Les jeux sont dans le dossier /usr/games."
echo "   Pour y jouer, faites :"
echo "   1. cd /usr/games"
echo "   2. ./nomdujeu (Ex: ./rogue ou ./snake)"
echo ""
echo "🚨 Redémarre le serveur avec : **reboot**"
echo "=================================================="
