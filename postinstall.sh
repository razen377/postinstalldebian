#!/bin/bash
    # Installation
    apt update && apt upgrade -y
    apt install -y ssh zip unzip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx winbind samba

    # 1. Ajout des alias de coloration syntaxique à /root/.bashrc
    echo "export LS_OPTIONS='--color=auto'" >> /root/.bashrc
    echo "eval \"\$(dircolors)\"" >> /root/.bashrc
    echo "alias ls='ls \$LS_OPTIONS'" >> /root/.bashrc
    echo "alias ll='ls \$LS_OPTIONS -l'" >> /root/.bashrc

    # --- Section de configuration de nsswitch.conf ---
    # 2. Suppression du fichier existant
    rm -f /etc/nsswitch.conf

    # 3. Recréation du fichier avec le contenu spécifié
    cat /etc/nsswitch.conf

passwd:          files systemd winbind
group:           files systemd winbind
shadow:          files systemd
gshadow:         files systemd

hosts:           files dns wins
networks:        files

protocols:       db files
services:        db files
ethers:          db files
rpc:             db files

netgroup:        nis

    # --------------------------------------------------

# Les commandes ci-dessous s'afficheront car elles sont hors du bloc silencieux
echo ""
echo "=================================================="
echo "Tout est installé et configuré !"
echo "Redémarre le serveur avec : reboot"
echo "=================================================="
