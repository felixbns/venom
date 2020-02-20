# coding: utf8

import hashlib
import argparse
import time

start_time = time.time()

def check_password(hash, password):
	if(hashlib.md5(password).hexdigest().upper()==hash.upper()):
		print("\033[32m\033[1m [+]\033[00m\033[36m Mot de passe cracké : \033[00m" + str(password))
		elapsed_time = time.time() - start_time
		print("\033[32m\033[1m [+]\033[00m\033[36m Temps de crackage : "+str(elapsed_time)+" secondes\033[00m")
		quit()

def count_print(i):
	i=i+1
	if(i%1000000==0):
		print(str(i/1000000)+" 000 000 mots de passe testés.")
	return i


### BEGIN BRUTE FORCE ATTACK

chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.;,"

def bruteforce_length(hash, init_password, target_length, current_length, i):
	if(current_length==target_length):
		i = count_print(i)
		check_password(hash, init_password)
	else:
		for c in chars:
			i = bruteforce_length(hash, init_password+c, target_length, current_length+1, i)
	return i

def bruteforce_attack(hash, max_length):
	i=0
	for l in range(1,max_length+1):
		i = bruteforce_length(hash, "", l, 0, i)

### END BRUTE FORCE ATTACK

### REPLACEMENTS

def get_transformations(password, replacements, from_index):
	if(from_index==len(replacements)):
		return [password]
	else:
		res = []
		nexts = get_transformations(password, replacements, from_index+1)
		repl = replacements[from_index]
		for t in nexts:
			res.append(t)
			transformation = t.replace(repl[0], repl[1])
			if(transformation!=t):
				res.append(transformation)
		return res

### FIN REMPLACEMENTS

### BEGIN SIMPLE DICTIONARY ATTACK

def dictionary_attack(hash, dict_filename):
	i=0
	with open(dict_filename) as f:
		for line in f:
			i = count_print(i)
			password = line.rstrip()
			check_password(hash, password)

### END SIMPLE DICTIONARY ATTACK

### BEGIN DICTIONARY ATTACK WITH REPLACEMENTS

def dict_attack_with_replacements(hash, dict_filename, replacements):
	i=0
	with open(dict_filename) as f:
		for line in f:
			password = line.rstrip()
			transformations = get_transformations(password, replacements, 0)
			for t in transformations:
				check_password(hash, t)
				i = count_print(i)

### END DICTIONARY ATTACK WITH REPLACEMENTS

### BEGIN TARGETED ATTACK

def generate_possibilities(combination, words):
	result = [combination]
	for w in words:
		without = set(words)
		without.remove(w)
		new_combination = list(combination)
		new_combination.append(w)
		result.extend(generate_possibilities(new_combination, without))
	return result

def targeted_attack(hash, words):
	possibilities = map(lambda l: "".join(l), generate_possibilities([], words))
	i=0
	for p in possibilities:
		password = p.rstrip()
		transformations = get_transformations(password, replacements, 0)
		for t in transformations:
			check_password(hash, t)
			i = count_print(i)

### END TARGETED ATTACK

parser = argparse.ArgumentParser(description="Simple crackeur de mots de passe. ")
parser.add_argument("hash", help="Hash MD5 pour la mot de passe à cracker.")
parser.add_argument("method", help="Méthode de crack à utiliser. Les valeurs possibles sont : brute_force, dict, dict_repl, targeted.")
parser.add_argument("-l", "--length_max", type=int, default=5, help="Taille maximum à essayer en mode 'brute_force'. 5 est la valeur par défaut.")
parser.add_argument("-d", "--dictionary", default="", help="Lien vers la mordlist à utiliser pour le mode 'dict' ou 'dict_repl'.")
parser.add_argument("-w", "--words", default="", help="Liste des mots séparés par des virgules pour le mode 'targeted'.")
parser.add_argument("-r", "--replacements", default="", help="Liste des remplacement séparés par des virgules. A utiliser pour le mode 'dict_repl'." + "Chaque remplacement d'un terme 'o' par un terme 'n' doit être écrit 'o/n'.")
args = parser.parse_args()
remplacement="a/A,b/B,c/C,d/D,e/E,f/F,g/G,h/H,i/I,j/J,k/K,l/L,m/M,n/N,o/O,p/P,q/Q,r/R,s/S,t/T,u/U,v/V,w/W,x/X,y/Y,z/Z,e/3,i/1,o/0,I/1,E/3,O/0,e/€,E/€,a/@,A/@,u/µ,U/µ,e/é,e/è,e/ê,e/ë,u/ù,u/û,u/ü,a/à,a/â,a/ä,o/ô,o/ö,c/ç,e/&,E/&"
if(args.method=="brute_force"):
	bruteforce_attack(args.hash, args.length_max)

elif(args.method=="dict"):
	if(args.dictionary==""):
		print("La méthode 'dict'.")
		quit()
	dictionary_attack(args.hash, args.dictionary)

elif(args.method=="dict_repl"):
	if(args.dictionary==""):
		print("La méthode 'dict_repl' a besoin du lien vers la wordlist.")
		quit()
	remplaTotal=str(remplacement)+","+str(args.replacements)
	replacements = map(lambda r: r.split("/"), remplaTotal.split(","))
	dict_attack_with_replacements(args.hash, args.dictionary, replacements)

elif(args.method=="targeted"):
	if(args.words==""):
		print("La méthode 'targeted' a besoin d'au moins un argument 'mot_à_tester'")
		quit()
	words_set = set(args.words.split(","))
	replacements = map(lambda r: r.split("/"), remplacement.split(","))
	targeted_attack(args.hash, words_set)

else:
	print("\033[31m\033[1m [-]\033[00m\033[36m La méthode de crackage '"+args.method+"' n'existe pas.\033[00m")
	quit()

print("\n\033[31m\033[1m [-]\033[00m\033[36m Le crackage a échoué, nous n'avons pas réussi à trouver le mot de passe avec la méthode choisie.\033[00m")
