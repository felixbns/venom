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

actualmac=`macchanger --show eth0 | grep -i "current" | awk '{print $3}'` > /dev/null 2>&1

echo -e "
$GREEN$BOLD [+]$DEFAULT$CYAN Votre adresse MAC actuelle : $actualmac$DEFAULT
"


echo -e "$BLUE [...]$DEFAULT$CYAN Changement de votre adresse MAC... $DEFAULT
"
sleep 0.4
char1=`tr -cd A-F0-9 < /dev/urandom | head -c 2 ; echo ""` > /dev/null 2>&1
char2=`tr -cd A-F0-9 < /dev/urandom | head -c 2 ; echo ""` > /dev/null 2>&1
char3=`tr -cd A-F0-9 < /dev/urandom | head -c 2 ; echo ""` > /dev/null 2>&1
char4=`tr -cd A-F0-9 < /dev/urandom | head -c 2 ; echo ""` > /dev/null 2>&1
char5=`tr -cd A-F0-9 < /dev/urandom | head -c 2 ; echo ""` > /dev/null 2>&1
char6=`tr -cd A-F0-9 < /dev/urandom | head -c 2 ; echo ""` > /dev/null 2>&1

macchanger --mac=$char1:$char2:$char3:$char4:$char5:$char6 eth0 > /dev/null 2>&1

newmac=`macchanger --show eth0 | grep -i "current" | awk '{print $3}'` > /dev/null 2>&1

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Votre adresse MAC est désormais :$DEFAULT $newmac$DEFAULT"



sleep 1

echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s



cd
cd $path/../
./suite.sh
