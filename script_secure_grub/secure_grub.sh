#!/bin/bash

# |-------------------------------------------------------------------------------------------|
# |        Ce script à été réaliser dans le but de sécurisé les ordinateurs utilisant grub en |
# | les os de la même manières que avant. Ce script a été fait par RRTracer . Tous droit      |
# | réserver.                                                                                 |
# |  Ce code est sous license : Licence Creative-Commons by-sa                                |
# |  Lien de la license :                                                                     |
# |         https://creativecommons.org/licenses/by-sa/2.0/fr/                                |
# | Cela signifie que vous pouvez télécharger, utiliser tout ou partie, modifier, partager ce |
# | code à votre guise.                                                                       |
# |                                                                                           |
# |      En contrepartie, cela implique que si vous les utilisez, vous devrez :               |
# |                                                                                           |
# |              les partager sous une licence au moins équivalente (libre)                   |
# |                                                                                           |
# |             marquer le nom de l'auteur de manière explicite.                              |
# |                                                                                           |
# |-------------------------------------------------------------------------------------------|

if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté avec les privilèges root."
    exit 1
fi

echo "Entrez un user pour le grub : "
read -s grub_user
echo "Entrez le mot de passe pour GRUB :"
read -s grub_password

grub_password_hash=$(grub-mkpasswd-pbkdf2 <<< "$grub_password" | grep 'grub.pbkdf2' | awk '{print $NF}')

echo "Ajout du mot de passe chiffré dans /etc/grub.d/40_custom..."

echo "
# Script : secure_grub.sh
set superusers=\"$grub_user\"
password_pbkdf2 $grub_user $grub_password_hash
" >> /etc/grub.d/40_custom

echo "Mise à jour de GRUB..."
update-grub

echo "Modification du fichier /boot/grub/grub.cfg pour ajouter l'option --unrestricted..."

debian_added=false
windows_added=false

while IFS= read -r line; do
    if [[ $line =~ "menuentry.*Debian" && $debian_added == false ]]; then
        sed -i "/menuentry.*Debian/ s/$/ --unrestricted/" /boot/grub/grub.cfg
        debian_added=true
    fi
    
    if [[ $line =~ "menuentry.*Windows" && $windows_added == false ]]; then
        sed -i "/menuentry.*Windows/ s/$/ --unrestricted/" /boot/grub/grub.cfg
        windows_added=true
    fi
done < /boot/grub/grub.cfg

echo "GRUB a été configuré avec succès et protégé avec un mot de passe."
echo "Si vous avez oublié le mot de passe, aucun contournement n'est possible."
echo "Redémarrez votre machine pour que les changements prennent effet."

exit 0
