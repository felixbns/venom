#!/bin/bash

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
path=`pwd` > /dev/null 2>&1

resize -s 50 140 | grep "gfdsqjhgfdezscvvvf" > /dev/null 2>&1

clear

echo -e "$BOLD$RED
 _  __   _   _____       ___   _       _           ___   _____   _   _____   __   _  
| | |  \ | | |_   _|    /   | | |     | |         /   | |_   _| | | /  _  \ |  \ | | 
| | |   \| |   | |     / /| | | |     | |        / /| |   | |   | | | | | | |   \| | 
| | | |\   |   | |    / /_| | | |     | |       / /_| |   | |   | | | | | | | |\   | 
| | | | \  |   | |   /  __  | | |___  | |___   /  __  |   | |   | | | |_| | | | \  | 
|_| |_|  \_|   |_|  /_/   |_| |_____| |_____| /_/   |_|   |_|   |_| \_____/ |_|  \_|"
echo -e "
      _____   _____       
     |  _  \ | ____|       ██    ██  ███████  ███    ██   ██████   ███    ███
     | | | | | |__         ██    ██  ██       ████   ██  ██    ██  ████  ████
     | | | | |  __|         ██  ██  █████    ██ ██  ██  ██    ██  ██ ████ ██
     | |_| | | |___         ██  ██  ██       ██  ██ ██  ██    ██  ██  ██  ██
     |_____/ |_____|         ████  ██       ██   ████  ██    ██  ██      ██
			      ██  ███████  ██    ███   ██████   ██      ██$DEFAULT

"

echo -e "$ORANGE$BOLD [!]$DEFAULT$CYAN Attention, pas d'inquiétudes, l'installation complète de VENOM peut prendre 30 minutes, veillez à ce que la machine ne se mette pas en veille afin d'être sur de l'intégrité des installations.$DEFAULT"

sleep 3

echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN L'installation va démarrer.$DEFAULT"

echo -e "$BLUE [...]$DEFAULT$CYAN Installation des mises à jour logicielles.$DEFAULT"

cd
apt-get update
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Installation réussie !$DEFAULT"

echo -e "
$BLUE [...]$DEFAULT$CYAN Création du lanceur VENOM.$DEFAULT"

cd /bin/
echo "#!/bin/bash
cd $path/ && ./main.sh '$@'" >> venom
chmod +x venom > /dev/null 2>&1
sleep 0.78
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Création du lanceur effectuée !$DEFAULT"

echo -e "
$BLUE [...]$DEFAULT$CYAN Autorisation d'éxécution des fichiers.$DEFAULT"

cd $path
chmod +x *
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Autorisation effectuée !$DEFAULT"

cd
echo -e "
$BLUE [...]$DEFAULT$CYAN Activation de la recherche rapide Metasploit.$DEFAULT"

systemctl start postgresql > /dev/null 2>&1
msfdb init > /dev/null 2>&1
echo "db_rebuild_cache" > $path/logs/cache_metasploit
msfconsole -q -r $path/logs/cache_metasploit
exit
rm $path/logs/cache_metasploit > /dev/null 2>&1
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Installation effectuée !$DEFAULT"

cd
echo -e "
$BLUE [...]$DEFAULT$CYAN Installation de MORPHEUS.$DEFAULT"

git clone https://github.com/r00t-3xp10it/morpheus.git
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Installation effectuée !$DEFAULT"

cd
echo -e "
$BLUE [...]$DEFAULT -$CYAN Installation de UFONET.$DEFAULT"

git clone https://github.com/epsylon/ufonet.git
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Installation effectuée !$DEFAULT"

cd
echo -e "
$BLUE [...]$DEFAULT -$CYAN Installation de HATKEY.$DEFAULT"

git clone https://github.com/enddo/hatkey.git
cp $path/fonctions/HatKey/HatKey2.py /root/HatKey/ > /dev/null 2>&1
cp $path/fonctions/HatKey/HatKey3.py /root/HatKey/ > /dev/null 2>&1
cp $path/fonctions/HatKey/Server.py /root/HatKey/System/ > /dev/null 2>&1
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Installation effectuée !$DEFAULT"

cd
echo -e "
$BLUE [...]$DEFAULT -$CYAN Installation de CUPP.$DEFAULT"

git clone https://github.com/Mebus/cupp.git
cp $path/fonctions/cupp_args.py /root/cupp/ > /dev/null 2>&1
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Installation effectuée !$DEFAULT"

cd
echo -e "
$BLUE [...]$DEFAULT$CYAN Installation de MITMF.$DEFAULT"

cd
apt-get install python-dev python-setuptools libpcap0.8-dev libnetfilter-queue-dev libssl-dev libjpeg-dev libxml2-dev libxslt1-dev libcapstone3 libcapstone-dev libffi-dev file
pip install virtualenvwrapper
source /usr/bin/virtualenvwrapper.sh
source /usr/bin/virtualenvwrapper.sh
git clone https://github.com/byt3bl33d3r/MITMf
cd MITMf && git submodule init && git submodule update --recursive
pip install -U user_agents
pip install -r requirements.txt
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Installation effectuée !$DEFAULT"

cd
echo -e "
$BLUE [...]$DEFAULT$CYAN Copie de la wordlist 14 milliards de mots de passe.$DEFAULT"

cp /usr/share/wordlists/rockyou.txt.gz $path/wordlists/ > /dev/null 2>&1
gzip -d $path/wordlists/rockyou.txt.gz
mv $path/wordlists/rockyou.txt $path/wordlists/liste001
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Copie effectuée !$DEFAULT"

cd
echo -e "
$BLUE [...]$DEFAULT$CYAN Installation de GOOGLER.$DEFAULT"

cd /tmp
git clone https://github.com/jarun/googler.git
cd googler
sudo make install
cd auto-completion/bash/
sudo cp googler-completion.bash /etc/bash_completion.d/
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Installation effectuée !$DEFAULT"

echo -e "
$BLUE [...]$DEFAULT$CYAN Installation des dépendance pour IP-LOCATOR.$DEFAULT"

cd
cpan WWW::Mechanize
cpan install JSON
echo -e "$GREEN$BOLD [+]$DEFAULT$CYAN Installation effectuée !$DEFAULT"



sleep 1


echo ""
echo -e -n "$MAGENTA [>]$CYAN Appuiez sur ENTRER pour lancer VENOM ou éxécutez la commande$ORANGE venom$CYAN dans un terminal : $DEFAULT$CYAN"
read -e -p "
" -n 1 -s

cd
cd $path
./main.sh
