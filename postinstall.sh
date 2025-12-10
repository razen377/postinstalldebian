#!/bin/bash

# ================================================
# Script d'installation et configuration automatique
# d'un serveur Debian/Ubuntu minimal
# Auteur : GDX
# Date   : 2025
# ================================================

set -e  # Arrête le script dès la première erreur

echo "=================================================="
echo "Mise à jour du système"
echo "=================================================="
apt update && apt upgrade -y

echo "=================================================="
echo "Installation des outils de base"
echo "=================================================="
apt install -y \
    ssh \               # Serveur/client SSH (OpenSSH)
    zip unzip \         # Gestion des archives .zip
    nmap \              # Scanner de ports et découverte réseau
    locate \            # Recherche rapide de fichiers (mlocate)
    ncdu \              # Analyse d'utilisation disque en mode ncurses
    curl \              # Client HTTP/HTTPS en ligne de commande
    git \               # Client Git
    screen \            # Gestion de sessions terminal détachables
    dnsutils \          # Contient dig, nslookup, etc.
    net-tools \         # ifconfig, netstat, route, etc. (anciennes commandes)
    sudo \              # Gestion des droits super-utilisateur
    lynx                # Navigateur web en mode texte

# Indexation initial pour la commande locate
echo "Indexation de la base locate (updatedb)..."
updatedb

echo "=================================================="
echo "Installation de la couche NetBIOS / Samba (uniquement pour réseau local)"
echo "=================================================="
echo "Attention : Samba/Winbind ne sera installé que si tu confirmes (reseau local uniquement)"
read -p "Veux-tu installer winbind + samba ? (o/N) " reponse
if [[ "$reponse" =~ ^[Oo]$ ]]; then
    apt install -y winbind samba

    # Ajout automatique de "wins" dans /etc/nsswitch.conf sur la ligne hosts
    echo "Modification de /etc/nsswitch.conf pour ajouter 'wins'..."
    if ! grep -q "wins" /etc/nsswitch.conf; then
        sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf
        echo "=> 'wins' ajouté à la ligne hosts"
    else
        echo "=> 'wins' déjà présent"
    fi
else
    echo "Samba/Winbind non installé (reseau exposé Internet ou choix utilisateur)"
fi

echo "=================================================="
echo "Personnalisation du .bashrc de root"
echo "=================================================="
BASHRC="/root/.bashrc"

# Décommenter les lignes 9 à 13 (partie alias de couleur et prompt amélioré chez Debian/Ubuntu)
echo "Décommentage des lignes 9 à 13 dans $BASHRC..."
sed -i '9,13s/^#//' "$BASHRC" 2>/dev/null || {
    echo "Impossible de modifier les lignes 9-13 (peut-être déjà décommentées ou version différente)"
}

# Forcer le rechargement du .bashrc pour la session en cours
source "$BASHRC" 2>/dev/null || true

echo "=================================================="
echo "Installation et configuration terminées !"
echo "=================================================="
echo "Tu peux maintenant :"
echo "  • Utiliser dig, nslookup (dnsutils)"
echo "  • Faire locate <fichier> (base déjà mise à jour)"
echo "  • Analyser le disque avec ncdu"
echo "  • Scanner avec nmap"
echo "  • Profiter d’un beau prompt coloré en root"
echo ""
echo "Pense à redémarrer si tu as installé Samba/Winbind :"
echo "   reboot"
echo "=================================================="
