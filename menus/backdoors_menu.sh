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

param=true

trap ctrl_c INT
ctrl_c() {
exit && exit && exit && exit && exit && exit
}

backdoor=`echo -e "$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                       Création d'une backdoor$DEFAULT$CYAN                       ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT"`

keylogger=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                       Création d'un KeyLogger$DEFAULT$CYAN                       ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
eth0=`ifconfig | grep -v -i "ether" | awk {'print $1'} | sed "s/.$//" | grep "eth" | tail -1` > /dev/null 2>&1
wlan0=`ifconfig | awk {'print $1'} | sed "s/.$//" | grep "wlan" | tail -1` > /dev/null 2>&1
IPeth0=`ifconfig $eth0 | grep -w "inet" | awk '{print $2}'` > /dev/null 2>&1
IPwlan0=`ifconfig $wlan0 | grep -w "inet" | awk '{print $2}'` > /dev/null 2>&1
if [ -z $wlan0 ];then
	if [ -z $IPeth0 ];then
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
waiting=0.015
indisponible="$RED$BOLD [-]$DEFAULT$CYAN Ce choix n'est pas disponible, connectez-vous à internet. $DEFAULT
"
OK="disponible"
NON="indisponible"

WIFI_COL=$RED
wifi=false
WIFI_A=$NON
INTERNET_A=$NON
INTERNET_COL=$RED
if [ "$interface" = "$eth0" ];then
	case $ipprivee in
		"127.0.0.1" | "" | " Non connecté  ") {
				INTERNET_A=$NON
				INTERNET_COL=$RED
			};;
		*){
				INTERNET_A=$OK
				INTERNET_COL=$GREEN$BOLD
			};;
	esac
fi

if [ "$interface" = "$wlan0" ];then
	case $ipprivee in
		"127.0.0.1" | "" | " Non connecté  ") {
				INTERNET_A=$NON
				INTERNET_COL=$RED
				WIFI_COL=$GREEN$BOLD
				wifi=true
				WIFI_A=$OK
			};;
		*){
				INTERNET_A=$OK
				INTERNET_COL=$GREEN$BOLD
				WIFI_COL=$GREEN$BOLD
				wifi=true
				WIFI_A=$OK
			};;
	esac
fi

CLASS=$DEFAULT$BLUE

echo -e "
$backdoor"
echo ""
echo -e "$INTERNET_COL  [1]$CLASS --$CYAN Wicrosoft Office Word macro (Windows)$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [2]$CLASS --$CYAN PDF infecté                 (Windows)$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [3]$CLASS --$CYAN Application Android         (Android)$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [4]$CLASS --$CYAN Shell Bash pour Linux       (Linux)$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [5]$CLASS --$CYAN Créer un KeyLogger$DEFAULT"
sleep $waiting
echo -e ""
echo -e "$ORANGE  [99]$CLASS -$CYAN Retour au menu$DEFAULT"

echo -e ""

action() {

	echo -e -n "$MAGENTA [>]$CYAN Choisissez une option ci-dessus : $DEFAULT"
	read choix



	case $choix in
	  	1) {
				if [ "$INTERNET_A" = "$OK" ];then
					clear
					echo "$backdoor"
					cd $path/../fonctions/payloads/
					param=false
					chmod +x word.sh
					./word.sh
				else
					echo -e "$indisponible"
				fi
			};;
	  	2) {
				if [ "$INTERNET_A" = "$OK" ];then
					clear
					echo "$backdoor"
					cd $path/../fonctions/payloads/
					param=false
					chmod +x pdf.sh
					./pdf.sh
				else
					echo -e "$indisponible"
				fi
			};;
		3) {
				if [ "$INTERNET_A" = "$OK" ];then
					clear
					echo "$backdoor"
					cd $path/../fonctions/payloads/
					param=false
					chmod +x apk.sh
					./apk.sh
				else
					echo -e "$indisponible"
				fi
			};;
		4) {
				if [ "$INTERNET_A" = "$OK" ];then
					clear
					echo "$backdoor"
					cd $path/../fonctions/payloads/
					param=false
					chmod +x bash.sh
					./bash.sh
				else
					echo -e "$indisponible"
				fi
			};;
		5) {
				if [ "$INTERNET_A" = "$OK" ];then
					clear
					echo "$keylogger"
					cd $path/../fonctions/
					param=false
					chmod +x keylogger.sh
					./keylogger.sh
				else
					echo -e "$indisponible"
				fi
			};;

		99) {
				clear
				echo "$retour"
				sleep 1
				cd $path/../
				param=false
				./main.sh
			};;
		exit) 	{
	  			echo -e "$exit"
				param=false
	  			sleep 1.2
	  			clear
	  			exit && exit && exit && exit
	    	};;
	  	*) 	{
	  			echo -e "$RED$BOLD [-]$DEFAULT$CYAN Ce choix n'est pas disponible. Réessayez. $DEFAULT
"
	    	};;
	esac
}

while [ "$param" = true ];do
	action
done
