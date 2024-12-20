#!/bin/bash

# Fichier des logs
LOG_FILE="$HOME/backup_usb.log"

# Fichier de verrouillage pour éviter les exécutions multiples
LOCK_FILE="/tmp/backup_usb.lock"

# Fichier des clés USB de confiance
TRUST_FILE="$HOME/trust.usb"

# Dossier de destination où les archives seront stockées
DEST_DIR="$HOME/.stock_usb"

# Début du script - log
echo "Script lancé à $(date)" >> "$LOG_FILE"

# Vérifier la présence du fichier de verrouillage
if [ -f "$LOCK_FILE" ]; then
    echo "Un processus de sauvegarde est déjà en cours. Abandon." >> "$LOG_FILE"
    exit 0
fi

# Créer un fichier de verrouillage
touch "$LOCK_FILE"

# Vérifier si le dossier de destination existe, sinon le créer
mkdir -p "$DEST_DIR"

# Détecter la clé USB (le dernier périphérique monté)
USB_PATH=$(lsblk -o MOUNTPOINT,NAME | grep "/media" | awk '{print $1}')

# Si aucun périphérique USB n'est trouvé, on quitte
if [ -z "$USB_PATH" ]; then
    echo "Aucune clé USB trouvée. Abandon." >> "$LOG_FILE"
    rm "$LOCK_FILE"
    exit 1
fi

# Identifier le périphérique USB par son UUID
USB_UUID=$(lsblk -o UUID,MOUNTPOINT | grep "$USB_PATH" | awk '{print $1}')

# Vérifier si la clé USB est déjà enregistrée comme de confiance
if [ -f "$TRUST_FILE" ] && grep -q "$USB_UUID" "$TRUST_FILE"; then
    echo "Clé USB de confiance détectée ($USB_UUID). Aucune action requise." >> "$LOG_FILE"
    rm "$LOCK_FILE"
    exit 0
fi

# Trouver le prochain numéro d'archive disponible
i=1
while [ -f "$DEST_DIR/stock_usb$i.tar.gz" ]; do
    ((i++))
done

# Créer l'archive
ARCHIVE_NAME="$DEST_DIR/stock_usb$i.tar.gz"
echo "Création de l'archive $ARCHIVE_NAME..." >> "$LOG_FILE"

# Archiver la clé USB
tar -czf "$ARCHIVE_NAME" -C "$USB_PATH" .

if [ $? -eq 0 ]; then
    echo "Sauvegarde terminée avec succès : $ARCHIVE_NAME" >> "$LOG_FILE"
else
    echo "Erreur lors de la sauvegarde de la clé USB." >> "$LOG_FILE"
fi

# Nettoyage du fichier de verrouillage
rm "$LOCK_FILE"

# Fin du script - log
echo "Fin du script à $(date)" >> "$LOG_FILE"
