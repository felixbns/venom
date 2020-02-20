## WRITTEN BY FELIX BONNES 2020 ##


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

exit=`echo -e "
$CYAN  ╔═════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                      Fin de l'éxécution de VENOM$DEFAULT$CYAN                    ║
  ╚═════════════════════════════════════════════════════════════════════╝$DEFAULT
  "`
trap ctrl_c INT
ctrl_c() {
echo "$exit"
sleep 2
clear
exit && exit && exit && exit && exit && exit
}

## VARIABLES :
timeImage=0.1
path=`pwd`

resize -s 50 140 > /dev/null 2>&1



## SCRIPT :

VERSION="3.0.0"

clear



## IMAGES ACCUEIL
echo -e "$RED$BOLD
	01    10  1001110  101    01  .100010.  110    100
	10    11  10       1001   00  01    01  0110  0100
	'00  10'  10110    00 10  11  00    10  11 1010 01
	 01  01   11       01  11 10  01    00  10 '11' 10
	 '0100'   01       01   1010  11    01  11      01$DEFAULT$BLUE -$GREEN Created by:$BOLD \e[4mFélix BONNES$DEFAULT$RED$BOLD
	   00     1001100  11    010  '100111'  01      10$DEFAULT$BLUE -$GREEN Version:$BOLD $VERSION$DEFAULT"
sleep $timeImage
clear
echo -e "$RED$BOLD
  	01    10  1001110  101    01   100010   110    100
	10    11 .10      .1001   00  01    01  0110  0100
	'00  10' 10110    00 10  11' 00'   10' 11 1010 01'
	 01  01  .11      .01  11 10  01   '00  10 '11'.10
	 '0100'   01      .01   1010  11'   01  11      01$DEFAULT$BLUE -$GREEN Created by:$BOLD \e[4mFélix BONNES$DEFAULT$RED$BOLD
	   00     1001100  11    010  '100111'  01      10$DEFAULT$BLUE -$GREEN Version:$BOLD $VERSION$DEFAULT"
sleep $timeImage
clear
echo -e "$RED$BOLD
  	01    10  1001110  101    01   100010   110    100
	10    11 .10      .1001   00 .01   .01 .0110  0100
	'00  10' 10110    00 10  11' 00'   10' 11 1010 01'
	 01  01  11       01  11 10  01    00  10 '11'.10
	 '0100'  .01'     '01'  1010  11   '01'.11      01$DEFAULT$BLUE -$GREEN Created by:$BOLD \e[4mFélix BONNES$DEFAULT$RED$BOLD
	   00     1001100  11   010'  '100111'  01      10$DEFAULT$BLUE -$GREEN Version:$BOLD $VERSION$DEFAULT"
sleep $timeImage
clear
echo -e "$RED$BOLD
  	01    10  1001110  101    01   100010   110    100
	10    11 .10      .1001   00 .01   .01 .0110  0100
	'00  10' 10110    00 10  11' 00'   10' 11 1010 01'
	 01  01 .11      .01  11 10 .01   .00 .10 '11'.10
	 '0100' 01'     .01'  1010' 11'  .01' 11     .01'$DEFAULT$BLUE  -$GREEN Created by:$BOLD \e[4mFélix BONNES$DEFAULT$RED$BOLD
	   00     1001100  11    010' '100111'  01      10$DEFAULT$BLUE -$GREEN Version:$BOLD $VERSION$DEFAULT"
sleep $timeImage
clear && clear && clear && clear
echo -e "$RED$BOLD
  	01    10  1001110  101    01   100010   110    100
	10    11 .10      .1001   00 .01   .01 .0110  0100
	'00  10' 10110    00 10  11' 00'   10' 11 1010 01'
	 01  01 .11      .01  11 10 .01   .00 .10 '11'.10
	 '0100'.01'     .01'  1010' 11'  .01'.11     .01'$DEFAULT$BLUE  -$GREEN Created by:$BOLD \e[4mFélix BONNES$DEFAULT$RED$BOLD
	   00  1001100  11'   010'  '100111' 01'     10$DEFAULT$BLUE    -$GREEN Version:$BOLD $VERSION$DEFAULT
"

cd $path

chmod +x suite.sh


eth0=`ifconfig | grep -v -i "ether" | awk {'print $1'} | sed "s/.$//" | grep "eth" | tail -1` > /dev/null 2>&1
wlan0=`ifconfig | awk {'print $1'} | sed "s/.$//" | grep "wlan" | tail -1` > /dev/null 2>&1
IPeth0=`ifconfig $eth0 | grep -w "inet" | awk '{print $2}'` > /dev/null 2>&1
IPwlan0=`ifconfig $wlan0 | grep -w "inet" | awk '{print $2}'` > /dev/null 2>&1
if [ -z "$wlan0" ];then
	if [ -z "$IPeth0" ];then
		interface=" lo  "
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

INTERNET_A=$NON
INTERNET_COL=$RED
WIFI_COL=$RED$BOLD
wifi=false
WIFI_A=$NON
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

lenIPprivee=`echo "$ipprivee" | wc -m` > /dev/null 2>&1
lenIPpublique=`echo "$ippublique" | wc -m` > /dev/null 2>&1
lengateway=`echo "$gateway" | wc -m` > /dev/null 2>&1
leninterface=`echo "$interface" | wc -m` > /dev/null 2>&1

zero1=" "
zero2="  "
zero3="   "
zero4="    "
zero5="     "
zero6="      "
zero7="       "
zero8="        "

if [ $leninterface = 5 ];then
	interface="$zero2$interface$zero2"
elif [ $leninterface = 6 ];then
	interface="$zero2$interface$zero1"
elif [ $leninterface = 7 ];then
	interface="$zero1$interface$zero1"
elif [ $leninterface = 8 ];then
	interface="$zero1$interface"
elif [ $leninterface = 9 ];then
	interface="$interface"
elif [ $leninterface = 1 ];then
	interface="$zero2 lo $zero2"
fi

if [ "$ipprivee" = "127.0.0.1" ];then
	ipprivee=" Non connecté  "
else
	if [ $lenIPprivee = 6 ];then
		ipprivee="$zero5$ipprivee$zero5"
	elif [ $lenIPprivee = 7 ];then
		ipprivee="$zero5$ipprivee$zero4"
	elif [ $lenIPprivee = 8 ];then
		ipprivee="$zero4$ipprivee$zero4"
	elif [ $lenIPprivee = 9 ];then
		ipprivee="$zero4$ipprivee$zero3"
	elif [ $lenIPprivee = 10 ];then
		ipprivee="$zero3$ipprivee$zero3"
	elif [ $lenIPprivee = 11 ];then
		ipprivee="$zero3$ipprivee$zero2"
	elif [ $lenIPprivee = 12 ];then
		ipprivee="$zero2$ipprivee$zero2"
	elif [ $lenIPprivee = 13 ];then
		ipprivee="$zero1$ipprivee$zero2"
	elif [ $lenIPprivee = 14 ];then
		ipprivee="$zero1$ipprivee$zero1"
	elif [ $lenIPprivee = 15 ];then
		ipprivee="$ipprivee$zero1"
	elif [ $lenIPprivee = 1 ];then
		ipprivee=" Non connecté  "
fi
fi

if [ $lenIPpublique = 8 ];then
	ippublique="$zero4$ippublique$zero4"
elif [ $lenIPpublique = 10 ];then
	ippublique="$zero3$ippublique$zero4"
elif [ $lenIPpublique = 11 ];then
	ippublique="$zero3$ippublique$zero3"
elif [ $lenIPpublique = 12 ];then
	ippublique="$zero2$ippublique$zero3"
elif [ $lenIPpublique = 13 ];then
	ippublique="$zero2$ippublique$zero2"
elif [ $lenIPpublique = 14 ];then
	ippublique="$zero1$ippublique$zero2"
elif [ $lenIPpublique = 15 ];then
	ippublique="$zero1$ippublique$zero1"
elif [ $lenIPpublique = 16 ];then
	ippublique="$ippublique$zero1"
elif [ $lenIPpublique = 1 ];then
	ippublique="  Non connecté  "
fi

if [ $lengateway = 8 ];then
	gateway="$zero4$gateway$zero4"
elif [ $lengateway = 9 ];then
	gateway="$zero3$gateway$zero4"
elif [ $lengateway = 10 ];then
	gateway="$zero3$gateway$zero3"
elif [ $lengateway = 11 ];then
	gateway="$zero2$gateway$zero3"
elif [ $lengateway = 12 ];then
	gateway="$zero2$gateway$zero2"
elif [ $lengateway = 13 ];then
	gateway="$zero1$gateway$zero2"
elif [ $lengateway = 14 ];then
	gateway="$zero1$gateway$zero1"
elif [ $lengateway = 15 ];then
	gateway="$gateway$zero1"
elif [ $lengateway = 1 ];then
	gateway=" Non connecté  "
fi

echo -e "$CYAN  ╔═══════════════════════════════════════════════════════════════════════════╗
  ║$RED$BOLD                         Votre configuration réseau$DEFAULT$CYAN                        ║
  ╠═════════════════╦═════════════════╦═════════════════╦═══════════╦═════════╣
  ║    IP Locale    ║   IP Publique   ║     Routeur     ║ Interface ║ Session ║
  ╠═════════════════╬═════════════════╬═════════════════╬═══════════╬═════════╣
  ║                 ║                 ║                 ║           ║         ║
  ║ $RED$ipprivee$DEFAULT$CYAN ║$RED$ippublique$DEFAULT$CYAN ║ $RED$gateway$DEFAULT$CYAN ║ $RED$interface$DEFAULT$CYAN  ║  $RED$session$DEFAULT$CYAN   ║
  ║                 ║                 ║                 ║           ║         ║
  ╚═════════════════╩═════════════════╩═════════════════╩═══════════╩═════════╝$DEFAULT
 "


echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s



./suite.sh
