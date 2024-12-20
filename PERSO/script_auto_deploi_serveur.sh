#!/bin/bash

# Variables 
counti=0
# Fonction 

show_help() {
    echo -e "
    ============================================================================================
    | Si vous voyez l'aide mais que vous ne l'avez pas appelée,                                |
    | c'est que l'appel du programme est faux ou que vous avez oublié de mettre un paramètre.  |
    ============================================================================================
    Usage : $0 [options]
    Options :
    -i : adresse IP à placer sur le serveur
    -p : paquet à installer ou vérifier l'installation et mettre à jour
    -u : mise à jour du serveur
    -h : afficher l'aide
    --help : afficher l'aide
    

    ATTENTION :
        NE PAS METTRE 2 FOIS LA MÊME OPTION !
    "
}
help_gespacquet(){
    echo -e "
    Mise à jour et contrôle de configuration du serveur, veuillez sélectionner l'option souhaité :
        1 : Mise à jour simple des paquets déjà présent
        2 : Mise à jour des paquets déjà présent et installation de nouveau paquets
        
        Si vous prennez installation de paquet, merci de donner un fichier [fichier].listp voir syntaxe Readme.md .
    "
}
gestionnaire_paquet(){    
    
    if [ "$1" == "1" ]; then
        echo "Mise à jour des paquets ..."
        update_maj
        echo "Mise à jour des paquets terminee ..."
    elif [ "$1" == "2" ]
    then
        echo "Mise à jour des paquets ..."
        update_maj
        echo "Mise à jour des paquets terminee ..."
        echo "Installation des paquets ..."
        installation_paquet
        echo "Installation des paquets terminee ..."

    fi
}
controle_config() {
    if [ -f serveur.conf ]
    then
        echo "Le fichier serveur.conf est présent"
    else
        echo "Le fichier serveur.conf n'est pas présent"
        exit 1
    fi


}
installation_paquet() {
    # installation des paquets qui sont stocker dans le fichier paquet.listp
        for i in $(cat paquet.listp)
        do
            sudo apt-get install $i
        done
}
update_maj() {
    # vérification de la présence du fichier 
    if [ -f paquet.listp ]
    then 
        echo "le fichier paquet.listp est présent"
    else
        echo "Le fichier paquet.listp n'est pas présent"
        exit 1
    fi
    echo "mise à jour des paquets du serveur"
    sudo apt update &&  sudo apt dist-upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean
    echo "end mise à jour"
}
# Test et blindage
[ $UID -ne 0 ] && { echo "Ce script doit être exécuté en tant que superutilisateur." ; exit 1; }
[ $# -gt 4 ] && show_help && exit 1
if [ $# -eq 1 ] 
then

fi
 [[ "$1" != "-h" ]] || [[ "$1" != "-p" ]] && show_help && exit 1
[ $# -eq 3 ] && show_help && exit 1
[ $# -lt 1 ] && show_help && exit 1
[ "$1" == "--help" ] || [ "$1" == "-h" ] && [ $# -ne 1 ] && show_help && exit 1
[ "$1" == "-u" ] && [ $# -ne 1 ] && show_help && exit 1 
[ "$1" != "-h" ] && [ "$1" != "--help" ] && [ "$1" != "-p" ] && [ "$1" != "-i" ] && [ "$1" != "-u" ] && show_help && exit 1
[ "$3" != "-h" ] && [ "$3" != "--help" ] && [ "$3" != "-p" ] && [ "$3" != "-i" ] && show_help && exit 1
[ "$1" == "$3" ] && show_help && exit 1

if [ "$1" == "-i" ]; then
    if [[ "$2" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "Adresse IP correcte : $2"
    else
        echo "Adresse IP incorrecte : $2"
        exit 1
    fi
elif [ "$3" == "-i" ]; then
    if [[ "$4" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "Adresse IP correcte : $4"
    else
        echo "Adresse IP incorrecte : $4"
        exit 1
    fi
fi

# Script

# Fin
exit 0
