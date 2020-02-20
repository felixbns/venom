#!/usr/bin/perl

use Socket;
use Term::ANSIColor;
use WWW::Mechanize;
use JSON;
 
print color 'reset';
@iphost=$ARGV[0] || die "Vous n'avez pas bien utilisé la commande\n";
my @ip = inet_ntoa(scalar gethostbyname("@iphost")or die "IP invalide !\n");
my @hn = scalar gethostbyaddr(inet_aton(@ip),AF_INET);
 
my $GET=WWW::Mechanize->new();
    $GET->get("http://ip-api.com/json/@ip"); # JSON API OF IP-API.COM
    my $json = $GET->content();
 
 
my $info = decode_json($json);
# Json API Response :
# A successful request will return, by default, the following:
#{
#    "status": "success",
#    "country": "COUNTRY",
#    "countryCode": "COUNTRY CODE",
#    "region": "REGION CODE",
#    "regionName": "REGION NAME",
#    "city": "CITY",
#    "zip": "ZIP CODE",
#    "lat": LATITUDE,
#    "lon": LONGITUDE,
#    "timezone": "TIME ZONE",
#    "isp": "ISP NAME",
#    "org": "ORGANIZATION NAME",
#    "as": "AS NUMBER / NAME",
#   "query": "IP ADDRESS USED FOR QUERY"
# }
# INFOS OF JSON API ...
print "\n";
print "\e[32m\e[1m [+]\e[00m\e[36m Organisation : \e[00m";
print $info->{'as'}, "\n";
print "\e[32m\e[1m [+]\e[00m\e[36m Fournisseur :  \e[00m", $info->{'isp'}, "\n";
print "\e[32m\e[1m [+]\e[00m\e[36m Pays :         \e[00m";
print $info->{'country'}," - ", $info->{'countryCode'}, "\n";
print "\e[32m\e[1m [+]\e[00m\e[36m Ville :        \e[00m";
print $info->{'city'}, "\n";
print "\e[32m\e[1m [+]\e[00m\e[36m Région :       \e[00m";
print $info->{'regionName'}, "\n";
print "\e[32m\e[1m [+]\e[00m\e[36m Localisation : ", "Latitude :\e[00m " , $info->{'lat'}, " \e[00m\e[36m - Longitude :\e[00m ", $info->{'lon'}, "\n";
print "\e[32m\e[1m [+]\e[00m\e[36m Heure :        \e[00m", "Fuseau horaire : " , $info->{'timezone'}, " - Zone : ", $info->{'timezone'}, "\n";
print "\e[32m\e[1m [+]\e[00m\e[36m Nom/Numéro :   \e[00m", $info->{'as'}, "\n";
print "\e[32m\e[1m [+]\e[00m\e[36m Code pays :    \e[00m", $info->{'countryCode'}, "\n"; 
print "\e[32m\e[1m [+]\e[00m\e[36m Statut :       \e[00m", $info->{'status'}, "\n"; 
print "\n";
# EOF
