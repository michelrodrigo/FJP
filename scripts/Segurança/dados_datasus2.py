# -*- coding: utf-8 -*-
"""
Created on Mon Dec  6 09:04:54 2021

@author: michel
"""

import pandas as pd
import numpy as np
from urllib.request import urlopen, Request
from bs4 import BeautifulSoup
import time

#!pip install -q Requests
import requests


def header(simples = True):
  if simples:
    headers = {'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36'}
  else:
    headers = {'Connection': 'keep-alive',
               'Content-Length': '1245',
               'Cache-Control': 'max-age=0',
               'Upgrade-Insecure-Requests': '1',
               'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
               'Origin': 'http://tabnet.datasus.gov.br',
               'Content-Type': 'application/x-www-form-urlencoded',
               'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
               'Referer': 'http://tabnet.datasus.gov.br/cgi/tabcgi.exe?sia/cnv/qauf.def',
               'Accept-Encoding': 'gzip, deflate',
               'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7',
               'Cookie': 'TS014879da=01e046ca4c4b528d8038c3c1e0eb3ac1687076d3618aac675f8ebc75416f233485b65400dbd667eeb5b19b7b05251ff99f1cf8b0ec',
               'Host': 'tabnet.datasus.gov.br'}

  return headers

def ultimo_dado_disponivel(link = "http://tabnet.datasus.gov.br/cgi/deftohtm.exe?sim/cnv/pext10mg.def", código = False):  
  headers = header()
  r = requests.get(link, headers = headers)
  soup = BeautifulSoup(r.text, 'html.parser').findAll("div", {"class" : "corpoperiodo"})
  if código:
    str1 = soup[1].find('option').get("value")
    str2 = str1.partition('.dbf')[0]
    ultimo_codigo = str2.partition('qauf')[2]
    return ultimo_codigo

  else:
    ultimo_dado = soup[1].find('option').get_text().split('\r\n')[0].strip()
    return print('O último dado disponível é: {}'.format(ultimo_dado))

def scraping_datasus(ano, mes, producao_ambulatorial = True, link = "http://tabnet.datasus.gov.br/cgi/tabcgi.exe?sia/cnv/qauf.def"):

  ano_f = str(ano)[2:]
  if len(str(mes)) == 1:
    mes_f = '0' + str(mes)
  else:
    mes_f = str(mes)
  
  periodo = ano_f + mes_f
  ultimo_pulicado = ultimo_dado_disponivel(código=True)
  comp = int(ultimo_pulicado) >= int(periodo)

  if comp:
    if producao_ambulatorial:
      form_producao = "Linha=Ano%2Fm%EAs_processamento&Coluna=Grupo_procedimento&Incremento=Qtd.apresentada&Arquivos=qauf{}.dbf&SRegi%E3o=TODAS_AS_CATEGORIAS__&pesqmes2=Digite+o+texto+e+ache+f%E1cil&SUnidade_da_Federa%E7%E3o=13&pesqmes3=Digite+o+texto+e+ache+f%E1cil&SProcedimento=TODAS_AS_CATEGORIAS__&SGrupo_procedimento=TODAS_AS_CATEGORIAS__&pesqmes5=Digite+o+texto+e+ache+f%E1cil&SSubgrupo_proced.=TODAS_AS_CATEGORIAS__&pesqmes6=Digite+o+texto+e+ache+f%E1cil&SForma_organiza%E7%E3o=TODAS_AS_CATEGORIAS__&SComplexidade=TODAS_AS_CATEGORIAS__&SFinanciamento=TODAS_AS_CATEGORIAS__&pesqmes9=Digite+o+texto+e+ache+f%E1cil&SSubtp_Financiament=TODAS_AS_CATEGORIAS__&pesqmes10=Digite+o+texto+e+ache+f%E1cil&SRegra_contratual=TODAS_AS_CATEGORIAS__&SCar%E1ter_Atendiment=TODAS_AS_CATEGORIAS__&SGest%E3o=TODAS_AS_CATEGORIAS__&SDocumento_registro=TODAS_AS_CATEGORIAS__&SEsfera_administrat=TODAS_AS_CATEGORIAS__&STipo_de_prestador=TODAS_AS_CATEGORIAS__&pesqmes16=Digite+o+texto+e+ache+f%E1cil&SNatureza_Jur%EDdica=TODAS_AS_CATEGORIAS__&pesqmes17=Digite+o+texto+e+ache+f%E1cil&SEsfera_Jur%EDdica=TODAS_AS_CATEGORIAS__&SAprova%E7%E3o_produ%E7%E3o=TODAS_AS_CATEGORIAS__&pesqmes19=Digite+o+texto+e+ache+f%E1cil&SProfissional_-_CBO=TODAS_AS_CATEGORIAS__&formato=table&mostre=Mostra"
      form_data = form_producao.format(periodo)
      headers = header(simples = False)
      r = requests.post("http://tabnet.datasus.gov.br/cgi/tabcgi.exe?sia/cnv/qauf.def", data = form_data, headers = headers)
    else:
      form_valor = "Linha=Ano%2Fm%EAs_processamento&Coluna=Grupo_procedimento&Incremento=Valor_apresentado&Arquivos=qauf{}.dbf&SRegi%E3o=TODAS_AS_CATEGORIAS__&pesqmes2=Digite+o+texto+e+ache+f%E1cil&SUnidade_da_Federa%E7%E3o=13&pesqmes3=Digite+o+texto+e+ache+f%E1cil&SProcedimento=TODAS_AS_CATEGORIAS__&SGrupo_procedimento=TODAS_AS_CATEGORIAS__&pesqmes5=Digite+o+texto+e+ache+f%E1cil&SSubgrupo_proced.=TODAS_AS_CATEGORIAS__&pesqmes6=Digite+o+texto+e+ache+f%E1cil&SForma_organiza%E7%E3o=TODAS_AS_CATEGORIAS__&SComplexidade=TODAS_AS_CATEGORIAS__&SFinanciamento=TODAS_AS_CATEGORIAS__&pesqmes9=Digite+o+texto+e+ache+f%E1cil&SSubtp_Financiament=TODAS_AS_CATEGORIAS__&pesqmes10=Digite+o+texto+e+ache+f%E1cil&SRegra_contratual=TODAS_AS_CATEGORIAS__&SCar%E1ter_Atendiment=TODAS_AS_CATEGORIAS__&SGest%E3o=TODAS_AS_CATEGORIAS__&SDocumento_registro=TODAS_AS_CATEGORIAS__&SEsfera_administrat=TODAS_AS_CATEGORIAS__&STipo_de_prestador=TODAS_AS_CATEGORIAS__&pesqmes16=Digite+o+texto+e+ache+f%E1cil&SNatureza_Jur%EDdica=TODAS_AS_CATEGORIAS__&pesqmes17=Digite+o+texto+e+ache+f%E1cil&SEsfera_Jur%EDdica=TODAS_AS_CATEGORIAS__&SAprova%E7%E3o_produ%E7%E3o=TODAS_AS_CATEGORIAS__&pesqmes19=Digite+o+texto+e+ache+f%E1cil&SProfissional_-_CBO=TODAS_AS_CATEGORIAS__&formato=table&mostre=Mostra"
      form_data = form_valor.format(periodo)
      headers = header(simples = False)
      r = requests.post("http://tabnet.datasus.gov.br/cgi/tabcgi.exe?sia/cnv/qauf.def", data = form_data, headers = headers)
    

    soup = BeautifulSoup(r.text, 'html.parser')
    colunas = soup.find('h1', {'class':'Nivel0'}).parent.th.get_text().split('\r\n')
    while len(colunas) > 10:
      colunas.remove('')

    zero_data = np.zeros(shape=(1,10))
    df = pd.DataFrame(zero_data, columns = colunas)
    index_dt = pd.date_range('{}-{}-01'.format(ano,mes), periods=1, freq='M')
    df = df.set_index(index_dt)
    df.index = df.index.strftime('%m-%Y')

    df_valor = pd.read_html(r.text, decimal = ',')
    valores = df_valor[0].iloc[2].values    
    count = 0
    for valor in valores:
      df.iloc[0,count] = valor
      count += 1

    return df     

  else: 
    print('A informação do mês {} do ano {} não está disponível.'.format(mes,ano))
    
    
def scraping_datasus_ano(ano, producao_ambulatorial = True, link = "http://tabnet.datasus.gov.br/cgi/tabcgi.exe?sia/cnv/qauf.def"):
  for i in range(1,13):
    if i == 1:
      if producao_ambulatorial:
        df = scraping_datasus(ano,i)
      else:
        df = scraping_datasus(ano,i, False)
    else:
      if producao_ambulatorial:
        df_append = scraping_datasus(ano,i)
        df = df.append(df_append)
      else:
        df_append = scraping_datasus(ano,i, False)
        df = df.append(df_append)
    
    time.sleep(10)
    
  return df


def tratamento_dados(dados):
  df_processed = dados
  df_processed = df_processed.drop('Ano/mês processamento', axis = 1)

  linhas = df_processed.shape[0]
  colunas = df_processed.shape[1]

  for col in range(0,colunas):
    for lin in range(0,linhas):
      valor = df_processed.iloc[lin,col]
      df_processed.iloc[lin,col] = float(valor.replace('.','').replace(',','.'))
  
  return df_processed

ultimo_dado_disponivel()