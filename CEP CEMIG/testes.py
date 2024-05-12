# -*- coding: utf-8 -*-
"""
Created on Tue Aug 16 11:00:59 2022

@author: michel
"""

import pandas as pd
dados_cemig = pd.read_excel('H:\FJP\CEP CEMIG\Coord_Cep.xlsx')
dados_cadunico = pd.read_excel('H:\FJP\CEP CEMIG\TESTEDADOSJUIZDEFORACEP.xlsx')


a = dados_cemig.loc[:, ['NOM_LOGRAD','COD_CEP']]

b= a.groupby( [ 'COD_CEP', 'NOM_LOGRAD'] ).size().to_frame(name = 'count').reset_index()

c = b.groupby('COD_CEP')['NOM_LOGRAD'].count()
        
       