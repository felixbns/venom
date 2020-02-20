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

lancementMSF=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                        Lancement de METASPLOIT$DEFAULT$CYAN                      ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
lancementXERO=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                        Lancement de XEROSPLOIT$DEFAULT$CYAN                      ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
lancementETTER=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                          Lancement d'ETTERCAP$DEFAULT$CYAN                       ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
lancementMORPHEUS=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                         Lancement de MORPHEUS$DEFAULT$CYAN                       ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
ufonet=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                        Attaque Ddos via UFONET$DEFAULT$CYAN                      ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
listener=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                   Lancement du listener msfconsole$DEFAULT$CYAN                  ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`

retour=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                       Retour au menu principal$DEFAULT$CYAN                      ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
exit=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                      Fin de l'éxécution de VENOM$DEFAULT$CYAN                    ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`

#interface=`netstat -r | grep "default" | awk {'print $8'}`
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
OK="disponible"
NON="indisponible"
indisponible="$RED$BOLD [-]$DEFAULT$CYAN Ce choix n'est pas disponible, connectez-vous à internet. $DEFAULT
"
waiting=0.015

trap ctrl_c INT
ctrl_c() {
param=false
exit && exit && exit && exit
}




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
echo ""
echo -e "$GREEN$BOLD  [1]$CLASS --$CYAN Lancer la console Metasploit$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [2]$CLASS --$CYAN Scan du réseau$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [3]$CLASS --$CYAN Pentesting en réseau$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [4]$CLASS --$CYAN Pentesting$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [5]$CLASS --$CYAN Créer une backdoor$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [6]$CLASS --$CYAN Lancer un listener$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [7]$CLASS --$CYAN Attaque Ddos (ufonet)$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [8]$CLASS --$CYAN Craquer un hash$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [9]$CLASS --$CYAN Créer une wordlist$DEFAULT"
sleep $waiting
echo -e "$WIFI_COL  [10]$CLASS -$CYAN Attaques Wifi$DEFAULT"
sleep $waiting
echo -e ""
echo -e "$BLUE  [11]$CLASS -$CYAN Autres actions secondaires...$DEFAULT"
sleep $waiting

echo -e ""

action() {
	trap ctrl_c INT
	echo -e -n "$MAGENTA [>]$CYAN Choisissez une option ci-dessus : $DEFAULT"
	read choix



	case $choix in
	  	1) {
				clear
				echo "$lancementMSF"
				sleep $waiting
				cd
				param=false
				msfconsole
			};;
		2) {
				if [ "$INTERNET_A" = "$OK" ];then
					sleep 0
					cd menus/
					param=false
					chmod +x reseau.sh
					./reseau.sh
				else
					echo -e "$indisponible"
				fi
			};;
		3) {
				if [ "$INTERNET_A" = "$OK" ];then
					sleep 0
					cd menus/
					param=false
					chmod +x pentesting_reseau.sh
					./pentesting_reseau.sh
				else
					echo -e "$indisponible"
				fi
			};;
		4) {
				if [ "$INTERNET_A" = "$OK" ];then
					sleep 0
					cd menus/
					param=false
					chmod +x pentesting.sh
					./pentesting.sh
				else
					echo -e "$indisponible"
				fi
			};;
		5) {
				if [ "$INTERNET_A" = "$OK" ];then
					sleep 0
					cd menus/
					param=false
					chmod +x backdoors_menu.sh
					./backdoors_menu.sh
				else
					echo -e "$indisponible"
				fi
			};;
		6) {
				if [ "$INTERNET_A" = "$OK" ];then
					clear
					echo "$listener"
					sleep $waiting
					cd fonctions/
					param=false
					chmod +x listener.sh
					./listener.sh
				else
					echo -e "$indisponible"
				fi
			};;
		7) {
				sleep 0
				cd menus/
				param=false
				chmod +x ufonet.sh
				./ufonet.sh
			};;
		8) {
				sleep 0
				cd menus/
				param=false
				chmod +x pwd_crack.sh
				./pwd_crack.sh
			};;
		9) {
				sleep 0
				cd menus/
				param=false
				chmod +x wordlists.sh
				./wordlists.sh
			};;
		10) {
				if [ "$WIFI_A" = "$OK" ];then
					sleep 0
					cd menus/
					chmod +x wifi.sh
					./wifi.sh
				else
					echo -e "$RED$BOLD [-]$DEFAULT$CYAN Ce choix n'est pas disponible, connectez-vous avec l'interface 'wlan0'. $DEFAULT
"
				fi
			};;
		11) {
				sleep 0
				cd menus/
				param=false
				chmod +x secondaire.sh
				./secondaire.sh
			};;
		99) {
				echo -e "$RED$BOLD [-]$DEFAULT$CYAN Redémarrage. $DEFAULT
"
				param=false
	  			sleep 1.2
	  			clear
				chmod +x main.sh
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
