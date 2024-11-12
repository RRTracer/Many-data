#!/bin/bash

# |-------------------------------------------------------------------------------------------|
# |        Ce script a été réalisé dans le but de sécuriser les ordinateurs utilisant GRUB    |
# | pour protéger les OS tout en permettant un démarrage normal. Ce script a été écrit par    |
# | RRTracer. Tous droits réservés.                                                           |
# |  Ce code est sous licence : Licence Creative-Commons by-sa                                |
# |  Lien de la licence :                                                                     |
# |         https://creativecommons.org/licenses/by-sa/2.0/fr/                                |
# | Cela signifie que vous pouvez télécharger, utiliser tout ou partie, modifier, partager ce |
# | code à votre guise.                                                                       |
# |                                                                                           |
# |      En contrepartie, cela implique que si vous l'utilisez, vous devrez :                 |
# |                                                                                           |
# |              le partager sous une licence au moins équivalente (libre)                    |
# |                                                                                           |
# |             mentionner le nom de l'auteur de manière explicite.                           |
# |                                                                                           |
# |-------------------------------------------------------------------------------------------|

if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté avec les privilèges root."
    exit 1
fi

# Vérifier si expect est installé
if ! command -v expect &> /dev/null; then
    echo "Le paquet 'expect' est requis mais n'est pas installé."
    read -p "Voulez-vous l'installer maintenant ? (o/n) " choice
    if [[ "$choice" =~ ^[Oo]$ ]]; then
        apt update && apt install -y expect
        if [[ $? -ne 0 ]]; then
            echo "L'installation de 'expect' a échoué. Veuillez l'installer manuellement."
            exit 1
        fi
    else
        echo "Expect est nécessaire pour exécuter ce script. Veuillez l'installer et réessayez."
        exit 1
    fi
fi

echo "Entrez un utilisateur pour le GRUB : "
read grub_user

echo "Entrez le mot de passe pour GRUB :"
read -s grub_password

# Utiliser "expect" pour générer le hash de mot de passe pour grub
grub_password_hash=$(expect <<EOF
spawn grub-mkpasswd-pbkdf2
expect "Enter password: "
send "$grub_password\r"
expect "Reenter password: "
send "$grub_password\r"
expect eof
EOF
)
grub_password_hash=$(echo "$grub_password_hash" | grep 'grub.pbkdf2' | awk '{print $NF}')

echo "Ajout du mot de passe chiffré dans /etc/grub.d/40_custom..."

echo "
# Script : secure_grub.sh
set superusers=\"$grub_user\"
password_pbkdf2 $grub_user $grub_password_hash
" >> /etc/grub.d/40_custom

echo "Mise à jour de GRUB..."
update-grub

echo "Modification du fichier /boot/grub/grub.cfg pour ajouter l'option --unrestricted..."

# Modifier les lignes de menu Debian et Windows pour ajouter --unrestricted après "os"
sed -i '/menuentry.*Debian/ s/\(os\)/\1 --unrestricted/' /boot/grub/grub.cfg
sed -i '/menuentry.*Windows/ s/\(os\)/\1 --unrestricted/' /boot/grub/grub.cfg


echo "GRUB a été configuré avec succès et protégé par un mot de passe."
echo "Si vous avez oublié le mot de passe, aucun contournement n'est possible."
echo "Redémarrez votre machine pour que les changements prennent effet."

# Nettoyage des variables afin d'éviter le stockage en cahce
unset grub_user grub_password grub_password_hash

exit 0
