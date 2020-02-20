# coding: utf8

from random import randint
import argparse

parser = argparse.ArgumentParser(description="Créateur de wordlists spéciales.")

parser.add_argument("nbchar", type=int, default=2, help="(int) Nombre de caractère entre chaque séparations")
parser.add_argument("nbpart", type=int, default=1, help="(int) Nombre de fois à répéter le schéma")
parser.add_argument("words", type=str, default="", help="(string) Mots ou lettres à inclure")
parser.add_argument("sep", type=str, default="", help="(string) Caractère(s) de séparation des mots ou lettres")

args = parser.parse_args()

mdp = []
part = []

def motdepasse(nbchar, nbpart, words, sep):
    for a in range(nbpart):
        for b in range(nbchar):
            part.append(words[randint(0,len(words)-1)])
        part.append(sep)
    mdp = ''.join(part[len(part)-(nbpart*nbchar+nbpart*len(sep)):len(part)-1])
    return mdp


def liste(number):
    mdpList = []
    count = 0
    while count < number:
        pwd = motdepasse(args.nbchar, args.nbpart, words, args.sep)
        if not pwd in mdpList:
            count += 1
            mdpList.append(pwd)
            print(pwd)

words = list(args.words)

nb = len(words)**(args.nbchar*args.nbpart)
liste(nb-(0.005*nb))
