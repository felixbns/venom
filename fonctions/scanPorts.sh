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
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s
cd
cd $path/../
./suite.sh
}


echo -e -n "$MAGENTA [>]$CYAN Entrez l'IP de la machine ciblée : $DEFAULT"
read cible

echo -e "$BLUE [...]$DEFAULT$CYAN Chargement... $DEFAULT
"

scanPorts=`nmap -sS -sU -T4 $cible | grep "^[0-9]"` > /dev/null 2>&1

if [ -z "$scanPorts" ];then
	echo -e "$RED$BOLD [-]$DEFAULT$CYAN Aucun port ouvert n'a été détecté sur la machine $cible. $DEFAULT"
else 
	echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Les ports ouverts de la machine $cible sont : $DEFAULT
"

	echo "$scanPorts"

fi


sleep 1

echo -e -n "
$MAGENTA [>]$CYAN Voulez-vous connaître l'état de port(s) en particulier ? (o/n) : $DEFAULT"
read ouinon


case $ouinon in
  	o) {			
			echo -e -n "$MAGENTA [>]$CYAN Entrez le(s) port(s) à scanner (séparez-les par des virgules) : $DEFAULT"
			read port

			echo -e "$BLUE [...]$DEFAULT$CYAN Chargement... $DEFAULT
			"

			scanPort2=`nmap -p $port $cible | grep "^[0-9]"` > /dev/null 2>&1

			echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN L'état du port $port la machine $cible est : $DEFAULT
			"

			echo "$scanPort2"

			echo ""
			echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
			read -e -p "
" -n 1 -s
			cd
			cd $path/../
			./suite.sh
		};;
	O) {
						
			echo -e -n "$MAGENTA [>]$CYAN Entrez le port à scanner : $DEFAULT"
			read port

			echo -e "$BLUE [...]$DEFAULT$CYAN Chargement... $DEFAULT
			"

			scanPort2=`nmap -p $port $cible | grep "^[0-9]"`

			echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN L'état du port $port la machine $cible est : $DEFAULT
			"

			echo "$scanPort2"

			echo ""
			echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
			read -e -p "
" -n 1 -s
			cd
			cd $path/../
			./suite.sh
		};;
	*) 	{
  			echo ""
			echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
			read -e -p "
" -n 1 -s
			cd
			cd $path/../
			./suite.sh
    	};;
esac
