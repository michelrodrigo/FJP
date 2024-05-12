# -*- coding: utf-8 -*-
"""
Created on Wed Dec  1 09:27:49 2021

@author: michel

script para extração dos dados de população
"""

import pandas as pd

#endereço onde está salvo o arquivo com os dados da população
path_populacao = r'H:\\FJP\\scripts\\Segurança\\IMRS2021 - BASE DEMOGRAFIA 2000 a 2020.xlsx'

data = pd.read_excel (path_populacao, usecols="B, D, G") #código do município, ano e população
a = data[data['ANO']==2020] #Filtering dataframe
b = pd.merge(a, pd.DataFrame(codigos), on=['IBGE6'], how='left')
