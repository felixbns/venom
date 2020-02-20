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

crackhash=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                           Craquer un hash$DEFAULT$CYAN                           ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT"`
brute=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                        Crack par brute force$DEFAULT$CYAN                        ║
  ╠═════════════════════════════════════════════════════════════════════╣
  ║ Test de toutes les combinaisons possibles de mots de passe.         ║
  ║ Le temps nécessaire pour trouver le mot de passe peut devenir très  ║
  ║ long. 25% des mots de passe craqués en moyenne.                     ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
dict=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                        Crack par dictionnaire$DEFAULT$CYAN                       ║
  ╠═════════════════════════════════════════════════════════════════════╣
  ║ Test de toutes les combinaisons possibles de mots de passe dans une ║
  ║ liste de mot de passe donnée.                                       ║
  ║ Le temps pour trouver le mot de passe est court si ce dernier est   ║
  ║ dans la wordlist. 47% des mots de passe craqués en moyenne.         ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
dictrepl=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                Crack par dictionnaire + remplacement$DEFAULT$CYAN                ║
  ╠═════════════════════════════════════════════════════════════════════╣
  ║ Test de toutes les combinaisons possibles de mots de passe dans une ║
  ║ liste de mot de passe donnée. Les remplacements permettent de       ║
  ║ changer certains caractères des mots de la liste afin d'augementer  ║
  ║ les chances de trouver le bon mot de passe. Pourcentage moyen de    ║
  ║ mots de passe craqués avec cette méthode : 57%.                     ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
target=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                             Crack ciblé$DEFAULT$CYAN                             ║
  ╠═════════════════════════════════════════════════════════════════════╣
  ║ Vous entrez les mots de passes dont il est possible que votre       ║
  ║ victime ait fait usage. Un dictionnaire de remplacements vient      ║
  ║ intervertir certains caractères fin de tester plus de possibilités  ║
  ║ Temps de cracquage dépend de votre connaissance de la victime.      ║
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
			};;
	esac
fi

trap ctrl_c INT
ctrl_c() {
echo "" && echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
read -e -p "
" -n 1 -s
cd
cd $path/../
./suite.sh
}

CLASS=$DEFAULT$BLUE

echo -e "$crackhash"
echo ""
echo -e "$GREEN$BOLD  [1]$CLASS --$CYAN Crack par brute force$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [2]$CLASS --$CYAN Crack par dictionnaire$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [3]$CLASS --$CYAN Crack par dictionnaire + remplacement$DEFAULT"
sleep $waiting
echo -e "$GREEN$BOLD  [4]$CLASS --$CYAN Crack ciblé$DEFAULT"
sleep $waiting
echo -e ""
echo -e "$ORANGE  [99]$CLASS -$CYAN Retour au menu$DEFAULT"

echo -e ""

echo -e -n "$MAGENTA [>]$CYAN Choisissez une option ci-dessus : $DEFAULT"
read choix



case $choix in
  	1) {
			clear
			echo "$brute"
			sleep $waiting
			cd $path/../fonctions/pwd_cracker/
			param=false
			echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le hash à craquer : $DEFAULT"
			read hash_
			lenHash=`echo "$hash_" | wc -m` > /dev/null 2>&1
			if [ $lenHash = 33 ];then
				hash_type="MD5"
			elif [ $lenHash = 65 ];then
				hash_type="SHA256"
			else
				echo ""
				echo -e "$RED$BOLD [-]$DEFAULT$CYAN Le type de hash n'est pas reconnu.$DEFAULT"
				echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
				read -e -p "
				" -n 1 -s
				cd
				cd $path/../
				./suite.sh
			fi
			echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le nombre de caractères maximum à tester : $DEFAULT"
			read nbre
			let "a=62**$nbre"
			echo -e "$ORANGE [!]$DEFAULT$CYAN Nombre maximum de mots de passe à tester : $a.$DEFAULT"
			echo ""
			echo -e "$MAGENTA [...]$DEFAULT$CYAN Craquage du hash...$DEFAULT
"
			if [ "$hash_type" = "SHA256" ];then
				chmod +x pwd_cracker_sha256.py
				python pwd_cracker_sha256.py $hash_ brute_force -l $nbre
			elif [ "$hash_type" = "MD5" ];then
				chmod +x pwd_cracker_md5.py
				python pwd_cracker_md5.py $hash_ brute_force -l $nbre
			else
				echo -e "$RED$BOLD [-]$DEFAULT$CYAN Vous n'avez pas saisi un choix valide ! Redémarrage. $DEFAULT"
	  			sleep 2
	  			cd $path/
	  			./pwd_crack.sh
			fi
			echo ""
			echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
			read -e -p "
			" -n 1 -s

			cd
			cd $path/../
			./suite.sh
		};;
  	2) {
			clear
			echo "$dict"
			sleep $waiting
			cd $path/../fonctions/pwd_cracker/
			param=false
			echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le hash à craquer : $DEFAULT"
			read hash_
			lenHash=`echo "$hash_" | wc -m` > /dev/null 2>&1
			if [ $lenHash = 33 ];then
				hash_type="MD5"
			elif [ $lenHash = 65 ];then
				hash_type="SHA256"
			else
				echo ""
				echo -e "$RED$BOLD [-]$DEFAULT$CYAN Le type de hash n'est pas reconnu.$DEFAULT"
				echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
				read -e -p "
				" -n 1 -s
				cd
				cd $path/../
				./suite.sh
			fi
			wordlist=$(zenity --title "Lien vers la wordlist" --filename=$path --file-selection --text "Choisissez la wordlist à utiliser.") > /dev/null 2>&1
			echo ""
			echo -e "$MAGENTA [...]$DEFAULT$CYAN Craquage du hash...$DEFAULT
"
			if [ "$hash_type" = "SHA256" ];then
				chmod +x pwd_cracker_sha256.py
				python pwd_cracker_sha256.py $hash_ dict -d $wordlist
			elif [ "$hash_type" = "MD5" ];then
				chmod +x pwd_cracker_md5.py
				python pwd_cracker_md5.py $hash_ dict -d $wordlist
			else
				echo -e "$RED$BOLD [-]$DEFAULT$CYAN Vous n'avez pas saisi un choix valide ! Redémarrage. $DEFAULT"
	  			sleep 2
	  			cd $path/
	  			./pwd_crack.sh
			fi
			echo ""
			echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
			read -e -p "
			" -n 1 -s

			cd
			cd $path/../
			./suite.sh
		};;
	3) {
			clear
			echo "$dictrepl"
			sleep $waiting
			cd $path/../fonctions/pwd_cracker/
			param=false
			echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le hash à craquer : $DEFAULT"
			read hash_
			lenHash=`echo "$hash_" | wc -m` > /dev/null 2>&1
			if [ $lenHash = 33 ];then
				hash_type="MD5"
			elif [ $lenHash = 65 ];then
				hash_type="SHA256"
			else
				echo ""
				echo -e "$RED$BOLD [-]$DEFAULT$CYAN Le type de hash n'est pas reconnu.$DEFAULT"
				echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
				read -e -p "
				" -n 1 -s
				cd
				cd $path/../
				./suite.sh
			fi
			wordlist=$(zenity --title "Lien vers la wordlist" --filename=$path --file-selection --text "Choisissez la wordlist à utiliser.") > /dev/null 2>&1
			echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez les remplacements à tester ('caract'/'rempla') (séparez les par une virgule) : $DEFAULT"
			read repl
			echo ""
			echo -e "$MAGENTA [...]$DEFAULT$CYAN Craquage du hash...$DEFAULT
"
			if [ "$hash_type" = "SHA256" ];then
				chmod +x pwd_cracker_sha256.py
				python pwd_cracker_sha256.py $hash_ dict_repl -d $wordlist -r $repl
			elif [ "$hash_type" = "MD5" ];then
				chmod +x pwd_cracker_md5.py
				python pwd_cracker_md5.py $hash_ dict_repl -d $wordlist -r $repl
			else
				echo -e "$RED$BOLD [-]$DEFAULT$CYAN Vous n'avez pas saisi un choix valide ! Redémarrage. $DEFAULT"
	  			sleep 2
	  			cd $path/
	  			./pwd_crack.sh
			fi
			echo ""
			echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
			read -e -p "
			" -n 1 -s

			cd
			cd $path/../
			./suite.sh
		};;
	4) {
			clear
			echo "$target"
			sleep $waiting
			cd $path/../fonctions/pwd_cracker/
			param=false
			echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le hash à craquer : $DEFAULT"
			read hash_
			lenHash=`echo "$hash_" | wc -m` > /dev/null 2>&1
			if [ $lenHash = 33 ];then
				hash_type="MD5"
			elif [ $lenHash = 65 ];then
				hash_type="SHA256"
			else
				echo ""
				echo -e "$RED$BOLD [-]$DEFAULT$CYAN Le type de hash n'est pas reconnu.$DEFAULT"
				echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
				read -e -p "
				" -n 1 -s
				cd
				cd $path/../
				./suite.sh
			fi
			echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez les mots de passe à essayer (séparez les par une virgule) : $DEFAULT"
			read mots
			echo ""
			echo -e "$MAGENTA [...]$DEFAULT$CYAN Craquage du hash...$DEFAULT
"
			if [ "$hash_type" = "SHA256" ];then
				chmod +x pwd_cracker_sha256.py
				python pwd_cracker_sha256.py $hash_ targeted -w $mots
			elif [ "$hash_type" = "MD5" ];then
				chmod +x pwd_cracker_md5.py
				python pwd_cracker_md5.py $hash_ targeted -w $mots
			else
				echo -e "$RED$BOLD [-]$DEFAULT$CYAN Vous n'avez pas saisi un choix valide ! Redémarrage. $DEFAULT"
	  			sleep 2
	  			cd $path/
	  			./pwd_crack.sh
			fi
			echo ""
			echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour afficher la suite : $DEFAULT"
			read -e -p "
			" -n 1 -s

			cd
			cd $path/../
			./suite.sh
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

