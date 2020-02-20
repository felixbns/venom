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

echo -e -n "$MAGENTA [>]$CYAN Entrez l'IP publique de la machine à localiser : $DEFAULT"
read cible



./iplocator.pl $cible 


echo -e -n "$MAGENTA [>]$CYAN Voulez-vous voir cette localisation sur une carte ? (o/n) $DEFAULT"
read ouinon

case $ouinon in
  	o) {
			chmod +x iplocator.pl
			lat=`./iplocator.pl $cible | grep "Localisation" | awk {'print $7'}`
			long=`./iplocator.pl $cible | grep "Localisation" | awk {'print $12'}`
			firefox http://maps.google.com/maps?q=$lat,$long&z=10&output=embed&iwloc=0 | grep "abracadabra" > /dev/null 2>&1
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
