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

secondaire=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                         Actions secondaires$DEFAULT$CYAN                         ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT"`
samba=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                      Démarrage du service SAMBA$DEFAULT$CYAN                     ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
recherchegoogle=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                      Recherche Google (googler)$DEFAULT$CYAN                     ║
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

echo -e "$secondaire"
echo ""
echo -e "$INTERNET_COL  [1]$CLASS --$CYAN Démarrer le service Samba (partage de fichiers)$DEFAULT"
sleep $waiting
echo -e "$INTERNET_COL  [2]$CLASS --$CYAN Recherche Google (googler)$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [3]$CLASS --$CYAN Changer votre adresse MAC$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [4]$CLASS --$CYAN Réinstaller VENOM$DEFAULT"
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
					echo "$samba"
					cd
					param=false
					/etc/init.d/smbd start > /dev/null 2>&1
					/etc/init.d/smbd restart > /dev/null 2>&1
					echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Le service Samba de partage de fichiers à démarré.$DEFAULT
"
					echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
					read -e -p "
" -n 1 -s
					cd $path/../
					./suite.sh
				else
					echo -e "$indisponible"
				fi
			};;
	  	2) {
				if [ "$INTERNET_A" = "$OK" ];then
					clear
					echo "$recherchegoogle"
					cd $path/../fonctions/
					param=false
					chmod +x recherche.sh
					./recherche.sh
				else
					echo -e "$indisponible"
				fi
			};;
		3) {
				clear
				echo "$changemac"
				cd $path/../fonctions/
				param=false
				echo -e -n "$MAGENTA [>]$CYAN Voulez-vous changer votre MAC en une nouvelle ou retrouver l'originale ? (nouv/origine) : $DEFAULT"
				read _type
				if [ "$_type" = "origine" ];then
					chmod +x originMAC.sh
					./originMAC.sh
				elif [ "$_type" = "nouv" ];then
					chmod +x changeMAC.sh
					./changeMAC.sh
				else
					echo -e "$RED$BOLD [-]$DEFAULT$CYAN Vous n'avez pas saisi un choix valide ! $DEFAULT"
		  			sleep 1.5
		  			cd $path/
		  			./secondaire.sh
				fi
			};;
		4) {
				clear
				param=false
				echo -e "$MAGENTA [>]$CYAN Entrez la phrase suivante pour confirmer la réinstallation : $DEFAULT"
				echo -e -n "$CYAN confirmer $DEFAULT"
				read conf
				case $conf in
				  	confirmer) {
							cd $path/../
							chmod +x installation.sh
							./installation.sh
						};;
					*) 	{
				  			echo ""
							echo -e -n "$RED$BOLD [-]$DEFAULT$CYAN Annulation de la réinstallation.$DEFAULT
"
							sleep 1.5
							cd
							cd $path/../
							param=false
							./main.sh
				    	};;
				esac
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
