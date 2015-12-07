#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 
# Convert a .csv en .dat.
# arg = filename sans le .csv.
# 

import sys, re, os, datetime

filename = sys.argv[1]
ifile = open(filename + ".csv", "r")
ofile = open(filename + ".dat", "w")

entete = ifile.readline()
if entete.find(";") !=-1:
    delimiter = ";"
elif entete.find(",") !=-1:
    delimiter = ","

# le fichier peut contenir des warning dans une colonne en plus, si on split juste les elements en colonnes on peut se trouver a inserer
# un warning sans le vouloir. On fixe donc le nombre de colonnes dans la suite.
num_colonnes = len(entete.split(delimiter))
if entete.split(delimiter)[0] == 'Date Time':
    with_date_time = True
else:
    with_date_time = False

# Traitement de la premiere ligne a part pour initialiser le temps.
line1 = ifile.readline()
elements = line1.split(delimiter)
# Conversion de la date en temps.
if (with_date_time):
    time1 = datetime.datetime.strptime(elements[0].replace('.',','), '%Y-%m-%d %H:%M:%S,%f')
    time2 = datetime.datetime.strptime(elements[0].replace('.',','), '%Y-%m-%d %H:%M:%S,%f')
    time21 = time2 - time1
    ofile.write(str(time21.total_seconds()) + " ")
else:
     ofile.write(elements[0] + " ")
for  j in range (1 , num_colonnes):
    # "\r\n" present a la fin du dernier element donc a enlever.
    if not elements[j].split("\r\n")[0]:
        ofile.write("50000000" + (" " if j != (num_colonnes-1) else "\n"))
    else:
        ofile.write(elements[j].split("\r\n")[0].replace(',','.') + (" " if j != (num_colonnes-1) else "\n")) #la fichier contient des virgules a virer.


# Lecture des autres lignes.
lines = ifile.readlines()

for line in lines:
    elements = line.split(delimiter)
    if (with_date_time):
        time2 = datetime.datetime.strptime(elements[0].replace('.',','), '%Y-%m-%d %H:%M:%S,%f')
        time21 = time2 - time1
        ofile.write(str(time21.total_seconds()) + " ")
    else:
        ofile.write(elements[0] + " ")
    for  j in range (1 , num_colonnes):
        if not elements[j].split("\r\n")[0]:
            ofile.write("50000000" + (" " if j != (num_colonnes-1) else "\n"))
        else:
            ofile.write(elements[j].split("\r\n")[0].replace(',','.') + (" " if j != (num_colonnes-1) else "\n"))
