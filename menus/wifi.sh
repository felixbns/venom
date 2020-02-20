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

wifi="
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                          Attaques par Wifi$DEFAULT$CYAN                          ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT"
aircrack=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                  Craquer le mot de passe d'un wifi$DEFAULT$CYAN                  ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
monitor=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD               Activer le mode monitor de la carte wifi$DEFAULT$CYAN              ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
managed=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD             Désactiver le mode monitor de la carte wifi$DEFAULT$CYAN             ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`


#interface=`netstat -r | grep "default" | awk {'print $8'}`
eth0=`ifconfig | grep -v -i "ether" | awk {'print $1'} | sed "s/.$//" | grep "eth"` > /dev/null 2>&1
wlan0=`ifconfig | awk {'print $1'} | sed "s/.$//" | grep "wlan"` > /dev/null 2>&1
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
OK="disponible"
NON="indisponible"
indisponible="$RED$BOLD [-]$DEFAULT$CYAN Ce choix n'est pas disponible, connectez-vous à internet. $DEFAULT
"
waiting=0.015
OK="disponible"
NON="indisponible"
if [ "$wlan0" = "wlan0" ];then 
	mode="$GREEN$BOLD managed$DEFAULT"
	actdesact="Activer"
elif [ "$wlan0" = "wlan0mon" ];then
	mode="$RED$BOLD monitor$DEFAULT"
	actdesact="Désactiver"
else
	mode=" inéfini"
	actdesact="Activer / désactiver"
fi

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
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                          Attaques par Wifi$DEFAULT$CYAN                          ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT"
echo ""
echo -e "$WIFI_COL  [1]$CLASS --$CYAN $actdesact le mode monitor de la carte wifi	(actuellement :$mode$CYAN)$DEFAULT"
sleep $waiting
echo -e "$WIFI_COL  [2]$CLASS --$CYAN Cracker le mot de passe d'un wifi$DEFAULT"
sleep $waiting
echo -e ""
echo -e "$ORANGE  [99]$CLASS -$CYAN Retour au menu$DEFAULT"

echo -e ""

action() {

	echo -e -n "$MAGENTA [>]$CYAN Choisissez une option ci-dessus : $DEFAULT"
	read choix



	case $choix in
	  	1) {
				if [ "$WIFI_A" = "$OK" ];then
					clear
					if [ "$wlan0" = "wlan0" ];then 
						echo "$monitor"
						sleep $waiting
						cd $path/../fonctions/
						param=false
						chmod +x monitor.sh
						./monitor.sh
					elif [ "$wlan0" = "wlan0mon" ];then
						echo "$managed"
						sleep $waiting
						cd $path/../fonctions/
						param=false
						chmod +x managed.sh
						./managed.sh
					else
						echo -e "$RED$BOLD [-]$DEFAULT$CYAN Le mode de votre carte wifi n'est pas reconnu. $DEFAULT
	"
					fi
				else
					echo -e "$indisponible"
				fi
				
			};;
	  	2) {
				if [ "$WIFI_A" = "$OK" ];then
					clear
					echo "$aircrack"
					sleep $waiting
					cd $path/../fonctions/
					param=false
					chmod +x aircrack.sh
					./aircrack.sh
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
