# -*- coding: utf-8 -*-
"""
Created on Mon Nov 22 09:07:27 2021

@author: michel

SCRIPT PARA OBTENÇÃO DOS DADOS DA PLATAFORMA DATASUS.

Para a realização do cálculo da taxa de homicídios, o usuário deve indicar onde 
está salvo o arquivo excel com os dados da população.

Ao final da execução do script, será gerado um arquivo excel que será salvo no 
mesmo local onde está salvo o arquivo com o script. O arquivo excel conterá, 
além das colunas correspondentes aos 14 indicadores, as colunas com código do 
município, nome e população.

Observação: 

como resolver o problema da versão do chrome driver: https://stackoverflow.com/questions/60296873/sessionnotcreatedexception-message-session-not-created-this-version-of-chrome/62127806

"""

#endereço onde está salvo o arquivo com os dados da população
path_populacao = r'H:\\FJP\\scripts\\Segurança\\IMRS2021 - BASE DEMOGRAFIA 2000 a 2020.xlsx'

#ano consulta
ano = 2020


#importa as bilbiotecas utilizadas
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
import pandas as pd
from bs4 import BeautifulSoup
import threading
import numpy
import re


driver = webdriver.Chrome(ChromeDriverManager().install())

#endereço base do datasus
url = "http://tabnet.datasus.gov.br/cgi/deftohtm.exe?sim/cnv/pext10mg.def"

#local onde está salvo o chromedriver
driver = webdriver.Chrome("H:\\FJP\\scripts\\Segurança\\chromedriver")

#endereço onde será salvo os dados baixados
path = 'H:\\FJP\\scripts\\Segurança'

chrome_options = webdriver.ChromeOptions()
prefs = {'download.default_directory' : path}
chrome_options.add_experimental_option('prefs', prefs)
driver = webdriver.Chrome(options=chrome_options)
driver.set_page_load_timeout(60)

driver.get(url)

lista = [['P_SUICIDIOS_SIM', '//*[@id="S7"]/option[4]'],
         ['P_MORTESTRAN_SIM', '//*[@id="S7"]/option[2]'],
         ['P_HOMI_SIM', '//*[@id="S7"]/option[5]'],
         ['P_HOMITX_SIM', '//*[@id="S7"]/option[5]'],
         ['P_HOMMENOR15_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig12"]', '//*[@id="S12"]/option[1]', '//*[@id="S12"]/option[2]', '//*[@id="S12"]/option[3]', '//*[@id="S12"]/option[4]', '//*[@id="S12"]/option[5]', '//*[@id="S12"]/option[6]', '//*[@id="S12"]/option[7]', '//*[@id="S12"]/option[8]'],
         ['P_HOM15A24_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig12"]', '//*[@id="S12"]/option[1]', '//*[@id="S12"]/option[9]', '//*[@id="S12"]/option[10]'],
         ['P_HOM25A29_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig12"]', '//*[@id="S12"]/option[1]', '//*[@id="S12"]/option[11]'],
         ['P_HOMMAIOR30_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig12"]', '//*[@id="S12"]/option[1]', '//*[@id="S12"]/option[12]', '//*[@id="S12"]/option[13]', '//*[@id="S12"]/option[14]', '//*[@id="S12"]/option[15]', '//*[@id="S12"]/option[16]', '//*[@id="S12"]/option[17]', '//*[@id="S12"]/option[18]', '//*[@id="S12"]/option[19]', '//*[@id="S12"]/option[20]', '//*[@id="S12"]/option[21]', '//*[@id="S12"]/option[22]'],
         ['P_HOMBRANCA_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig15"]', '//*[@id="S15"]/option[1]', '//*[@id="S15"]/option[2]'],
         ['P_HOMPRETA_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig15"]', '//*[@id="S15"]/option[1]', '//*[@id="S15"]/option[3]'],
         ['P_HOMPARDA_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig15"]', '//*[@id="S15"]/option[1]', '//*[@id="S15"]/option[5]'],
         ['P_HOMOUTROS_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig15"]', '//*[@id="S15"]/option[1]', '//*[@id="S15"]/option[4]', '//*[@id="S15"]/option[6]', '//*[@id="S15"]/option[7]'],
         ['P_HOMHOMEM_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig14"]', '//*[@id="S14"]/option[1]', '//*[@id="S14"]/option[2]'],
         ['P_HOMMULHER_SIM', '//*[@id="S7"]/option[5]', '//*[@id="fig14"]', '//*[@id="S14"]/option[1]', '//*[@id="S14"]/option[3]']
]

texto_comum = "Grande Grupo "+ ".*<br>"

codigos = []
municipios = []
 
#definição da função que faz a leitura dos dados da população
#devido ao fato do arquivo excel ter um tamanho considerável, a leitura demora
#o tempo de execução do script pode ser encurtado se essa operação for executada
#concomitantemente com a extração dos dados do datasus. Dessa forma, faz-se
#o use de threads.   
class leExcel(threading.Thread):
 
    def __init__(self, path):
        threading.Thread.__init__(self)
        self.path = path
        self.dados_pop = None
        self._return = None
        
    def run(self):
        print("Obtendo dados população")
        data = pd.read_excel (self.path, usecols="B, D, G") #colunas correspondentes ano código do município, ano e população
        self.dados_pop = data[(data['ANO'] == ano)] #Filtering dataframe
        print("Dados população obitidos.")
        self._return = self.dados_pop
        
    def join(self):
        threading.Thread.join(self)
        return self._return
        
#função que realiza a consulta ao datasus e salva os dados em um dataframe
def obtem_dados_datasus():

    print("Obtendo dados do datasus")
    print("Indicador: ")
    for indicador in lista:
       
        driver.get(url)
        
        html = driver.page_source
    
        # linha
        driver.find_element_by_xpath('//*[@id="L"]/option[1]').click()
        //*[@id="L"]/option[1]    
        # Coluna
        driver.find_element_by_xpath('//*[@id="C"]/option[9]').click()
        
        # Conteúdo
        driver.find_element_by_xpath('//*[@id="I"]/option[1]').click() #desmarca a opção de óbitos p/Residência
        driver.find_element_by_xpath('//*[@id="I"]/option[2]').click() #marca a opção de óbitos por Ocorrência
        
        # Exibir linhas zeradas
        driver.find_element_by_xpath('//*[@id="Z"]').click()
        
        # cid-10
        driver.find_element_by_xpath('//*[@id="fig7"]').click()   
        driver.find_element_by_xpath('//*[@id="S7"]/option[1]').click() #desmarca a opção todas as categorias
        
        for item in indicador:
    
            if indicador.index(item) != 0:
                driver.find_element_by_xpath(item).click()
            
        
        driver.find_element_by_xpath('/html/body/div/div/center/div/form/div[4]/div[2]/div[2]/input[1]').click()
    
        html = driver.page_source
        
        #if indicador[1] not in re.findall(texto_comum, html)[0]:
        #   print("ERRO: DADOS NÃO ENCONTRADOS - " + indicador[1])
        
        soup = BeautifulSoup(html, 'html.parser')
    
        tabdados = soup.select(".tabdados tbody tr td")
        tabdados = list(map(lambda node: node.get_text().strip(), tabdados))
    
        col_tabdados = soup.select(".tabdados th")
        col_tabdados = list(map(lambda node: node.get_text().strip(), col_tabdados))
    
        len_tabdados = len(tabdados[3:])
        len_col_tabdados = len(col_tabdados)
    
        nrow = int(len_tabdados / len_col_tabdados)
        ncol = int(len_col_tabdados)
    
        df_names = numpy.array(col_tabdados).reshape(1, ncol)
        df = numpy.array(tabdados[3:]).reshape(nrow, ncol)
        
        #df = numpy.vstack([df_names, df])
    
        if lista.index(indicador) == 0:
            codigos = []
            municipios = []
            for l in df[:, 0]:
                codigos.append(l[0:6])
                municipios.append(l[7:])
            resultado = pd.DataFrame(list(zip(codigos, municipios)), columns=['IBGE6', 'Municipio'])
            
        dados_atuais = pd.DataFrame(df[:, 1], columns= [indicador[0]])
        dados_atuais = dados_atuais.replace('-', '0').astype(int)
        resultado = pd.concat([resultado, dados_atuais], axis=1)
        
        print(indicador[0])
        
    print("Dados datasus obtidos.")
    return resultado

def Main():
    
    segundo_plano = leExcel(path_populacao)
    #segundo_plano.start()
    
    resultado = obtem_dados_datasus()
    
    print("Aguardando a importação dos dados da população finalizar.")
    dados_pop = segundo_plano.join()
    
    
    resultado['IBGE6'] = resultado['IBGE6'].astype(int)
    resultado = pd.merge(resultado, dados_pop[['IBGE6', 'D_POPTA']], on=['IBGE6'], how='left')
    resultado['P_HOMITX_SIM'] = (resultado['P_HOMITX_SIM'] / resultado['D_POPTA'] ) * 100000
    
    datatoexcel = pd.ExcelWriter('dados_datasus.xlsx')
  
    # write DataFrame to excel
    resultado.to_excel(datatoexcel)
  
    # save the excel
    datatoexcel.save()
    
if __name__=='__main__':
	Main()

'''
PRÓXIMOS PASSOS: DAR UMA OLHADA NOS SCRIPTS DE WEBSCRAPPING NO GITHUB E VERIFICAR
SE HÁ A POSSIBILIDADE DE FAZER UMA BUSCA POR PALAVRAS CHAVE E EM SEGUIDA OBTER O LINK 
PARA SER CLICADO.
'''