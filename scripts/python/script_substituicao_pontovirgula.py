# -*- coding: utf-8 -*-
"""
Created on Fri Oct  1 20:56:16 2021

@author: michel
"""

import pandas as pd
import chardet

nova_lista = []

with open(r'D:\Downloads\xae.txt', errors=('ignore')) as f: #endereço onde o arquivo original está salvo
    for line in f:
    contents = f.readlines()
    

with open("log.txt") as infile:
 
        do_something_with(line)

contents.pop(0) # retira a primeira linha



for line in contents:
   

    if line.count(';') > 24:        
        posicao = [pos for pos, char in enumerate(line) if char == '"']
        print(posicao)     
       
        pos_pontovirgula = []
        for i in range(1, round(len(posicao)/2)+1):
            aux_pos = line.find(';', posicao[i*2-2], posicao[i*2-1])
            if aux_pos != -1:
                pos_pontovirgula.append(aux_pos)

        for i in range(0, len(pos_pontovirgula)):    
            line = line[:pos_pontovirgula[i]] + ',' + line[pos_pontovirgula[i]+1:]
        
        

    nova_lista.append(line)
    
with open(r'H:\FJP\scripts\xaa.txt','w') as result_file: #endereço onde será salvo o arquivo corrigido
    for l in nova_lista:
        try:
            result_file.write(l)
        except:
            print(l)
        
