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

wordlist=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                   Création de wordlists spéciales$DEFAULT$CYAN                   ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT"`
wordlistPerso=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                 Création de wordlists personalisées$DEFAULT$CYAN                 ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
wordlistSpe=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                   Création de wordlists à schéma$DEFAULT$CYAN                    ║
  ╠═════════════════════════════════════════════════════════════════════╣
  ║ Exemple de schéma, de la forme : AB:1D:E9:GH:28:KL                  ║
  ║ Avec 2 caractères entre chaque séparation                           ║
  ║      6 parties                                                      ║
  ║      les caractères 'ABCDEFGHIJKL0123456789'                        ║
  ║      le caractère ':' constituant la séparation                     ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
wordlistSpeMots=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                   Création de wordlists à schéma$DEFAULT$CYAN                    ║
  ╠═════════════════════════════════════════════════════════════════════╣
  ║ Exemple de schéma, de la forme : lorem-ipsum-dor-sit-amet           ║
  ║ Avec 1 mot entre chaque séparation                                  ║
  ║      5 parties                                                      ║
  ║      les mots 'lorem,ipsum,dor,sit,amet'                            ║
  ║      le caractère '-' constituant la séparation                     ║
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

echo -e "$wordlist"
echo ""
echo -e "$GREEN$BOLD  [1]$CLASS --$CYAN Créer une wordlist schématique à caractères$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [2]$CLASS --$CYAN Créer une wordlist schématique à mots$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [3]$CLASS --$CYAN Créer une wordlist personalisée pour une victime connue$DEFAULT"
sleep $waiting
echo -e ""
echo -e "$ORANGE  [99]$CLASS -$CYAN Retour au menu$DEFAULT"

echo -e ""

action() {

	echo -e -n "$MAGENTA [>]$CYAN Choisissez une option ci-dessus : $DEFAULT"
	read choix



	case $choix in
	  	1) {
				clear
				echo "$wordlistSpe"
				sleep $waiting
				cd $path/../fonctions/wordlist/
				param=false
				chmod +x wordlist.py
				echo -e -n "$MAGENTA [>]$CYAN Entrez le nombre de caractères entre chaque séparation : $DEFAULT"
				read nbchar
				echo -e -n "$MAGENTA [>]$CYAN Entrez le nombre de parties du schéma : $DEFAULT"
				read nbpart
				echo -e -n "$MAGENTA [>]$CYAN Entrez les caractères qui consituerons les parties du schéma (abcdef) : $DEFAULT"
				read words
				echo -e -n "$MAGENTA [>]$CYAN Entrez le(s) caractère(s) qui consituera(ront) la séparation : $DEFAULT"
				read sep
				cd $path/../wordlists/
				chemin1=`pwd`
				cd $path
				echo -e -n "$MAGENTA [>]$CYAN Entrez le nom et le chemin vers lequel la wordlist sera stockée ($chemin1) : $DEFAULT"
				read path
				echo -e "$BLUE [>]$CYAN Création de la wordlist...$DEFAULT"
				python wordlist.py $nbchar $nbpart $words $sep > $path
				echo -e "$GREEN$BOLD [>]$DEFAULT$CYAN La wordlist a bien été créée vers $path.$DEFAULT"
				sleep 1
				cd $path/../
				param=false
				./main.sh
			};;
		2) {
				clear
				echo "$wordlistSpeMots"
				sleep $waiting
				cd $path/../fonctions/wordlist/
				param=false
				chmod +x wordlistMots.py
				echo -e -n "$MAGENTA [>]$CYAN Entrez le nombre de mots entre chaque séparation : $DEFAULT"
				read nbchar
				echo -e -n "$MAGENTA [>]$CYAN Entrez le nombre de parties du schéma : $DEFAULT"
				read nbpart
				echo -e -n "$MAGENTA [>]$CYAN Entrez les mots qui consituerons les parties du schéma (séparez-les par des virgules) (test,hello) : $DEFAULT"
				read words
				echo -e -n "$MAGENTA [>]$CYAN Entrez le(s) caractère(s) qui consituera(ront) la séparation : $DEFAULT"
				read sep
				cd $path/../wordlists/
				chemin1=`pwd`
				cd $path
				echo -e -n "$MAGENTA [>]$CYAN Entrez le nom et le chemin vers lequel la wordlist sera stockée ($chemin1) : $DEFAULT"
				read path
				echo -e "$BLUE [>]$CYAN Création de la wordlist...$DEFAULT"
				python wordlistMots.py $nbchar $nbpart $words $sep > $path
				echo -e "$GREEN$BOLD [>]$DEFAULT$CYAN La wordlist a bien été créée vers $path.$DEFAULT"
				sleep 1
				cd $path/../
				param=false
				./main.sh
			};;
		3) {
				clear
				echo "$wordlistPerso"
				sleep $waiting
				cd /root/cupp/
				param=false
				chmod +x cupp_args.py
				echo -e "$MAGENTA [>]$CYAN Entrez les informations suivantes qui aideront à l'élaboration de la wordlist.$DEFAULT"
				sleep 3
				echo -e "$ORANGE [!]$CYAN Entrez$ORANGE '-'$CYAN lorsque vous ne connaissez pas cette information.$DEFAULT"
				sleep 2
				echo -e -n "$MAGENTA [>]$CYAN Prénom : $DEFAULT"
				read prenom
				echo -e -n "$MAGENTA [>]$CYAN Nom de famille : $DEFAULT"
				read nom
				echo -e -n "$MAGENTA [>]$CYAN Surnom : $DEFAULT"
				read surnom
				echo -e -n "$MAGENTA [>]$CYAN Date de naissance (JJMMAAAA) : $DEFAULT"
				read ddn
				echo -e -n "$MAGENTA [>]$CYAN Prénom du partenaire : $DEFAULT"
				read prenom_part
				echo -e -n "$MAGENTA [>]$CYAN Surnom du partenaire : $DEFAULT"
				read surnom_part
				echo -e -n "$MAGENTA [>]$CYAN Date de naissance du partenaire (JJMMAAAA) : $DEFAULT"
				read ddn_part
				echo -e -n "$MAGENTA [>]$CYAN Prénom de l'enfant : $DEFAULT"
				read prenom_enf
				echo -e -n "$MAGENTA [>]$CYAN Surnom de l'enfant : $DEFAULT"
				read surnom_enf
				echo -e -n "$MAGENTA [>]$CYAN Date de naissance de l'enfant (JJMMAAAA) : $DEFAULT"
				read ddn_enf
				echo -e -n "$MAGENTA [>]$CYAN Nom de son animal : $DEFAULT"
				read animal
				echo -e -n "$MAGENTA [>]$CYAN Nom de la société chez qui il/elle travaille : $DEFAULT"
				read societe
				echo -e -n "$MAGENTA [>]$CYAN Autres mots pouvant être contenus dans son mot de passe (séparés par une virgule) : $DEFAULT"
				read words
				cd $path/../wordlists/
				chemin1=`pwd`
				cd $path
				echo -e -n "$MAGENTA [>]$CYAN Chemin d'export de la wordlist ($chemin1/wordlist.txt) : $DEFAULT"
				read chemin
				if [ "$chemin" = "-" ];then
					chemin="$chemin1/"
				fi
				cd /root/cupp/
				python3 cupp_args.py $prenom $nom $surnom $ddn $prenom_part $surnom_part $ddn_part $prenom_enf $surnom_enf $ddn_enf $animal $societe $words $chemin

				sleep 1
				cd $path/../
				param=false
				./main.sh
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
