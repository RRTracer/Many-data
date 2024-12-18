#!/bin/bash

# Dossier de destination où les archives seront stockées
DEST_DIR="$HOME/.stock_usb"

# Vérifier si le dossier de destination existe, sinon le créer
mkdir -p "$DEST_DIR"

# Détecter la clé USB (on suppose qu'il s'agit du dernier périphérique monté)
USB_PATH=$(lsblk -o MOUNTPOINT,NAME | grep "/media" | awk '{print $1}')

# Si aucun périphérique USB n'est trouvé, on quitte
if [ -z "$USB_PATH" ]; then
    echo "Aucune clé USB trouvée. Abandon."
    exit 1
fi

# Trouver le prochain numéro d'archive disponible
i=1
while [ -f "$DEST_DIR/stock_usb$i.tar.gz" ]; do
    ((i++))
done

# Créer l'archive
ARCHIVE_NAME="$DEST_DIR/stock_usb$i.tar.gz"
echo "Création de l'archive $ARCHIVE_NAME..."

# Créer l'archive tar.gz de la clé USB
tar -czf "$ARCHIVE_NAME" -C "$USB_PATH" .

echo "Sauvegarde terminée."
