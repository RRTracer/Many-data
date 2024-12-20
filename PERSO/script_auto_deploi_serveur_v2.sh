#!/bin/bash
# 
#
#
# Dépendence:
#           
#   
#   - nmap = pour le scan de services ouvert ppour le check security 
#   - openssl = pour la gest

################################################# [ VARIABLES ] ##################################################
oldIFS=$IFS # sauvegarde de mon internal field separator etant donner son importance en bash
IFS=$'\n' # nouvelle internal field separator
FICHIER_CONFIG="serveur.conf" # fichier de config
USER="" # Utilisateur unique
ssh_pub_key="" # Mettre la cles publique ici . 
conf_var=0
################################################# [ FONCTION ] ###################################################
rrtracer_style() {
    echo "                                                       _..._                                    ";
    echo "                                                    .-'_..._''.                                 ";
    echo "                                                  .' .'      '.\        __.....__               ";
    echo "                                                 / .'               .-''         '.             ";
    echo ".-,.--.  .-,.--.       .|   .-,.--.             . '                /     .-''\"'-.  \`.  .-,.--.  ";
    echo "|  .-. | |  .-. |    .' |_  |  .-. |     __     | |               /     /________\   \ |  .-. | ";
    echo "| |  | | | |  | |  .'     | | |  | |  .:--.'.   | |               |                  | | |  | | ";
    echo "| |  | | | |  | | '--.  .-' | |  | | / |   \ |  . '               \    .-------------' | |  | | ";
    echo "| |  '-  | |  '-     |  |   | |  '-  \`\" __ | |   \ '.          .   \    '-.____...---. | |  '-  ";
    echo "| |      | |         |  |   | |       .'.''| |    '. \`._____.-'/    \`.             .'  | |      ";
    echo "| |      | |         |  '.' | |      / /   | |_     \`-.______ /       \`''-...... -'    | |      ";
    echo "|_|      |_|         |   /  |_|      \ \._,\ '/              \`                         |_|      ";
    echo "                     \`'-'             \`--'  \`\"                                                  ";
}

config_et_controle(){
    if [ ! -f serveur.conf ]
    then 
        echo -e " Merci d'avoir un fichier de configuration aux même endroit que le script.
            Par ailleurs si le fichier de config ne respecte pas la syntaxe imposer dans l'example, les configurations ne se feront pas
            et le programme crachera ou encore pire, il configurera n'importe comment le serveur et alors là ... MISÈRE !

            FAITE CA BIEN !   
        "
    fi
    echo -e " Merci de me dire si c'est une configuration (tapez 1) ou si c'est un contrôle de configuration (tapez 2)"
    read choix8
    echo -e "\n\n"
    
    case $choix8 in
        1) 
            echo -e " début de la configuration ... \n\n"
            conf_var=1
            ;;
        2) 
            echo -e " Début du contrôle de vérification ... \n\n"
            conf_var=2
            ;;
        *) 
            echo -e " ERREUR : choix non disponible"
            exit 1
            ;;
    esac
    
    
    for ligne in $(<$FICHIER_CONFIG)
    do
        tmp_var=$(echo $ligne | cut -d ":" -f 1)
        tmp_var_2=$(echo $ligne | cut -d ":" -f 2)
        tmp_var_3=$(echo $ligne | cut -d "," -f 2)

        if [ $tmp_var == "user" ]
        then
            #check si le user exist 
            tmp=$(cat /etc/passwd | grep $tmp_var_2)
            if [ ! -s "$tmp" ]
            then 

                crypt_password=$(openssl passwd -1 "$tmp_var_3")
                useradd -p $crypt_password -m $tmp_var_2

                tmp=$(cat /etc/passwd | grep $tmp_var_2)
                if [ -s "$tmp" ]
                then 
                    echo " COOL : utilisateur correctement créé"
                    USER=$tmp_var
                else 
                    if [ $conf_var -eq 2 ]
                    then 
                        echo -e "Configuration de l'utilisateur conforme , useur déjà existant \n\n"
                    else
                        echo "ERROR: utilisateur n'a pas pus être créé "
                        exit 1
                fi
            else
                if [ $conf_var -eq 2 ]
                then 
                    echo -e "Configuration de l'utilisateur conforme , useur déjà existant \n\n"
                else
                    echo "ERROR: utilisateur existe déjà "
                    exit 1
                fi
            fi
        elif [ $tmp_var == "ip_machine" ]
        then
            interface=$(ip -br a | grep -vF DOWN | cut -d/ -f1 | grep -vF lo | cut -d " " -f 1) # récupere tout interface active exepter lo
            #interface=enp0s3 #enlever le premier commentaire de la ligne pour mettre vous meme l'interfaces. commenter la ligne du dessus pour plus de bonne pratique
            sudo echo -e "\n
            auto $interface
            iface $interface inet static
                    address $tmp_var_2 
                    netmask $tmp_var_3
             " >> /etc/network/interfaces

        elif [ $tmp == "hostname_machine" ]
        then 
            sudo echo "$tmp_var_2" >> /etc/hostname
        elif [ $tmp_var == "services" ] 
        then 
            tmp_stock=$(systemctl list-unit-files --type=service)
            for line in $tmp_stock
            do
                tmp1=$(echo $line | cut -d " " -f 1)
                if [ $tmp_var_2 == $tmp1 ]
                then 
                    sudo systemctl $tmp_var_3 $tmp_var_2
                    tmp2=$(systemctl status $tmp_var_2 | grep Active: | cut -d ":" -f 2 | cut -d " " -f 2)
                    if [ $tmp2 == $tmp_var_3 ]
                    then
                        echo " $tmp_var_2 est bien $tmp_var_3 "
                    else 
                        echo "ERREUR: problème lors de la validation , veuillez vérifier à posteriori le statut de $tmp_var_2 " 
                    fi
                fi
            done
        elif [ $tmp == "ssh_pu_key:" ]
        then
            echo $ssh_pub_key > ~/.ssh/authorized_keys/id_rsa
        fi
    done

}

check_seccurity() {

    if ! command -v nmap &> /dev/null
    then
        echo "Erreur : 'nmap' est requis mais n'est pas installé."
        exit 1
    fi
    res=$(sudo nmap -sS -sV -O -p- 127.0.0.1)
    echo -e "Voici les résultat de la commande nmap :\n"
    echo $res

    
}

update(){
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean -y 
}

install(){
    if [ -f paquet.list ]
    then 
        for i in $(cat paquet.list)
        do
            sudo apt install $i
        done
    else
        echo -e "
            Afin de poursuivre l'installation des paquets ,
            merci de fournir le fichier contenant les pacquets, un seul paquet par ligne     
        "
    fi 

}

menu() {
    clear
    rrtracer_style
    echo -e " \n\n\n
    
    bonjour, merci d'utliser le mon script. Que voulais vous faire ? \n

    1 : Mise à jour des paquets du serveur
    2 : Installation des paquets du serveur
    3 : Controle de la sécurité du serveur
    4 : Configurer le serveur
    5 : Quitter
    "
    read choix
    case $choix in
        1) update ;;
        2) install ;;
        3) check_seccurity ;;
        4) config ;;
        5) exit 0 ;;
        *) echo "ERREUR : choix non disponible" ;;
    esac

}
################################################# [ BLINDAGE  ] ###################################################
[ $UID -ne 0 ] && { echo "Ce script doit être exécuté en tant que superutilisateur." ; exit 1; }

################################################# [ SCRIPT ] #####################################################
menu


################################################# [ EXIT ] #######################################################

IFS=$oldIFS # remise en place de l'IFS
exit 0 
