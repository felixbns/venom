## Couleurs BASH
DEFAULT="\e[00m"
BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
ORANGE="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"

## Effets de texte (défaut, gras, souligné)
export DEF="\e[0;0m"
export BOLD="\e[1m"
export UNDER="\e[4m"


eth0=`ifconfig | grep -v -i "ether" | awk {'print $1'} | sed "s/.$//" | grep "eth" | tail -1` > /dev/null 2>&1
wlan0=`ifconfig | awk {'print $1'} | sed "s/.$//" | grep "wlan" | tail -1` > /dev/null 2>&1
IPeth0=`ifconfig $eth0 | grep -w "inet" | awk '{print $2}'` > /dev/null 2>&1
IPwlan0=`ifconfig $wlan0 | grep -w "inet" | awk '{print $2}'` > /dev/null 2>&1
if [ -z $wlan0 ];then
	if [ -z $IPeth0 ];then
		interface="lo"
	else
		interface=$eth0
	fi
else
	interface=$wlan0
fi
ipprivee=`ifconfig $interface | grep -w "inet" | awk '{print $2}'` > /dev/null 2>&1
ippublique=`wget http://checkip.dyndns.org -O - -o /dev/null | cut -d : -f 2 | cut -d \< -f 1` > /dev/null 2>&1
gateway=`ip route | grep "default" | awk {'print $3'}` > /dev/null 2>&1
session=`hostname` > /dev/null 2>&1
iprange=`ip route | grep "kernel" | awk {'print $1'}` > /dev/null 2>&1
path=`pwd` > /dev/null 2>&1


trap ctrl_c INT
ctrl_c() {
echo "" && echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s
cd
cd $path/../
./suite.sh
}

echo -e -n "$MAGENTA [>]$CYAN Entrez l'IP de la machine dont vous voulez connaître les détails : $DEFAULT"
read cible


echo -e "$BLUE [...]$DEFAULT$CYAN Recherche du nom de la machine et de l'utilisateur... $DEFAULT
"

nomCible=`nbtscan $cible | grep "server" | awk {'print $2'}` > /dev/null 2>&1

if [ -z "$nomCible" ]
then
	nomCible=`nbtscan -v $cible | grep "<" | sed -n '1p' | awk {'print $1'}` > /dev/null 2>&1
fi


if [ -z "$nomCible" ]
then
	nomCible="Introuvable"
fi


userCible=`nbtscan $cible | grep "$cible" | grep -v "NBT" | awk {'print $4'}` > /dev/null 2>&1


echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Nom du PC :$DEFAULT $nomCible"

if [ "$userCible" = "<unknown>" ];then
	echo -e "$RED$BOLD [-]$DEFAULT$CYAN Nom de l'utilisateur :$DEFAULT Indéchiffrable"
elif [ "$userCible" = "" ];then
	echo -e "$RED$BOLD [-]$DEFAULT$CYAN Nom de l'utilisateur :$DEFAULT Introuvable"
else
	echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Nom de l'utilisateur :$DEFAULT $userCible"
fi






echo -e "
$BLUE [...]$DEFAULT$CYAN Recherche de ports ouverts sur la machine... $DEFAULT"

portsCible=`nmap -sS -sU $cible | grep "^[0-9]"` > /dev/null 2>&1

if [ -z "$portsCible" ]
then
	echo -e "
$RED$BOLD [-]$DEFAULT$CYAN Les ports disponibles de la machine $cible n'ont pas pu être trouvés.$DEFAULT"
else
	echo -e "
$GREEN$BOLD [+]$DEFAULT$CYAN Ports disponibles de la machine $cible : $DEFAULT
"
	echo -e "$portsCible"
fi





echo -e "
$BLUE [...]$DEFAULT$CYAN Recherche de l'adresse MAC de la machine... $DEFAULT"

macCible=`nbtscan $cible | grep "$cible" | grep -v "NBT" | awk {'print $5'} | tr 'abcdefghijklmnopqrstuvwxyz' 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'` > /dev/null 2>&1

if [ -z "$macCible" ]
then
	echo -e "
$RED$BOLD [-]$DEFAULT$CYAN L'adresse MAC de la machine $cible n'a pas pu être trouvée.$DEFAULT"
else
	echo -e "
$GREEN$BOLD [+]$DEFAULT$CYAN Adresse MAC de la machine $cible :$DEFAULT $macCible"
fi






echo -e "
$BLUE [...]$DEFAULT$CYAN Recherche du système d'exploitation de la machine... $DEFAULT"

OSCible=`nmap -sV $cible | grep "Service Info" | awk {'print $4'}` > /dev/null 2>&1
OSCible2=`nmap -O $cible | grep "Running" | awk {'print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20'}` > /dev/null 2>&1

echo -e "
$GREEN$BOLD [+]$DEFAULT$CYAN Système d'exploitation de la machine : $DEFAULT$OSCible - $OSCible2
"






echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s



cd
cd $path/../
./suite.sh
