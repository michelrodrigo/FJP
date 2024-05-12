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

#endereço onde será salvo os dados baixados
path = 'H:\\FJP\\scripts\\Segurança'

#ano consulta
ano = 2020

#navegador - escolha o navegador, deixando a opção desejada descomentada
navegador = "Chrome"
#navegador = "Firefox"


#importa as bilbiotecas utilizadas
from selenium import webdriver
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
import pandas as pd
from bs4 import BeautifulSoup
import threading
import numpy



if navegador == "Chrome":
    driver = webdriver.Chrome(ChromeDriverManager().install())
    driver = webdriver.Chrome("H:\\FJP\\scripts\\Segurança\\chromedriver")  #local onde está salvo o chromedriver
    chrome_options = webdriver.ChromeOptions()
    prefs = {'download.default_directory' : path}
    chrome_options.add_experimental_option('prefs', prefs)
    driver = webdriver.Chrome(options=chrome_options)
    driver.set_page_load_timeout(60)
elif navegador == "Firefox":
    driver = webdriver.Firefox()

#endereço base do datasus
url = "http://tabnet.datasus.gov.br/cgi/deftohtm.exe?sim/cnv/pext10mg.def"




lista = [['P_SUICIDIOS_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X60-X84 Lesões autoprovocadas voluntariamente')]]"],
         ['P_MORTESTRAN_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'V01-V99 Acidentes de transporte')]]"],
         ['P_HOMI_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]"],
         ['P_HOMITX_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]"],
         ['P_HOMMENOR15_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]", "//img[../select[contains(@name,'SFaixa_Etária_det')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '0 a 6 dias')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '7 a 27 dias')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '28 a 364 dias')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., 'Menor 1 ano (ign)')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '1 a 4 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '5 a 9 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '10 a 14 anos')]]"],
         ['P_HOM15A24_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]", "//img[../select[contains(@name,'SFaixa_Etária_det')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '15 a 19 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '20 a 24 anos')]]"],
         ['P_HOM25A29_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]", "//img[../select[contains(@name,'SFaixa_Etária_det')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '25 a 29 anos')]]"],
         ['P_HOMMAIOR30_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]", "//img[../select[contains(@name,'SFaixa_Etária_det')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '30 a 34 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '35 a 39 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '40 a 44 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '45 a 49 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '50 a 54 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '55 a 59 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '60 a 64 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '65 a 69 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '70 a 74 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '75 a 79 anos')]]", "//select[@name='SFaixa_Etária_det']/*[text()[contains(., '80 anos e mais')]]"],
         ['P_HOMBRANCA_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]",  "//img[../select[contains(@name,'SCor/raça')]]", "//select[@name='SCor/raça']/*[text()[contains(., 'Branca')]]"],
         ['P_HOMPRETA_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]", "//img[../select[contains(@name,'SCor/raça')]]", "//select[@name='SCor/raça']/*[text()[contains(., 'Preta')]]"],
         ['P_HOMPARDA_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]", "//img[../select[contains(@name,'SCor/raça')]]", "//select[@name='SCor/raça']/*[text()[contains(., 'Parda')]]"],
         ['P_HOMOUTROS_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]", "//img[../select[contains(@name,'SCor/raça')]]", "//select[@name='SCor/raça']/*[text()[contains(., 'Indígena')]]", "//select[@name='SCor/raça']/*[text()[contains(., 'Amarela')]]", "//select[@name='SCor/raça']/*[text()[contains(., 'Ignorado')]]"],
         ['P_HOMHOMEM_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]", "//img[../select[contains(@name,'SSexo')]]", "//select[@name='SSexo']/*[text()[contains(., 'Masc')]]"],
         ['P_HOMMULHER_SIM', "//select[@name='SGrande_Grupo_CID10']/*[text()[contains(., 'X85-Y09 Agressões')]]", "//img[../select[contains(@name,'SSexo')]]", "//select[@name='SSexo']/*[text()[contains(., 'Fem')]]"]
]

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
        try:
            print("Obtendo dados população\n")
            data = pd.read_excel (self.path, usecols="B, D, G") #colunas correspondentes ano código do município, ano e população
            self.dados_pop = data[(data['ANO'] == ano)] #Filtering dataframe
            print("Dados população obtidos.")
            self._return = self.dados_pop
        except:
            print("Erro ao ler os dados da população.")
        
    def join(self):
        threading.Thread.join(self)
        return self._return
    
         
#função que realiza a consulta ao datasus e salva os dados em um dataframe
def obtem_dados_datasus():

    print("Obtendo dados do datasus")
    print("Indicador: ")
    for indicador in lista:
       
        try:
            driver.get(url)
            html = driver.page_source    
        except: 
            print("Erro ao acessar a URL. Verifique o acesso à internet e se o site DATASUS está no ar.")
            return -1
            
    
        # linha        
        try:
            driver.find_element(By.XPATH, "//select[@name='Linha']//option[@value='Município']").click()
        except:
            print("Erro ao selecionar a opção Município em Linha")
            return -1
            
        # Coluna
        try:
            driver.find_element(By.XPATH, "//select[@name='Coluna']//option[@value='Ano_do_Óbito']").click()
        except:
            print("Erro ao selecionar a opção Ano do Óbito em Coluna")
            return -1
        
        # Conteúdo   
        try:
            driver.find_element(By.XPATH, "//select[@name='Incremento']//option[@value='Óbitos_p/Residênc']").click()  #desmarca a opção de óbitos p/Residência
            driver.find_element(By.XPATH, "//select[@name='Incremento']//option[@value='Óbitos_p/Ocorrênc']").click()  #marca a opção de óbitos por Ocorrência
        except: 
            print("Erro ao selecionar a opção Óbitos p/ Ocorrência em Conteúdo")
            return -1
        
        # periodo
        try:
            opcoes = Select(driver.find_element(By.NAME, 'Arquivos'))
            opcao_default = opcoes.first_selected_option.text
            if(opcao_default != str(ano)):
                driver.fin_element(By.XPATH, "//select[@name='Arquivos']//option[contains(text(),"+str(ano)+")]").click()
        except:
            print("Erro ao selecionar o ano "+str(ano)+ " em Períodos disponíveis")
            return -1
                
        # Exibir linhas zeradas
        try:
            driver.find_element(By.XPATH, "//input[@name='zeradas']").click()
        except:
            print("Erro ao marcar a opção Exibir linhas zeradas")
            return -1
        
        # cid-10
        try:
            driver.find_element(By.XPATH, "//img[../select[contains(@name,'SGrande_Grupo_CID10')]]").click()   #procura pela imagem tal que o pai tem um filho select cujo nome contém o texto desejado, em outras palavras, procura pelo símbolo de mais próximo ao texto Grande Grupo CID10
            driver.find_element(By.XPATH, "//select[@name='SGrande_Grupo_CID10']//option[@value='TODAS_AS_CATEGORIAS__']").click()  #desmarca a opção todas as categorias
        except:
            print("Erro ao selecionar a opção Grande Grupo CID10")
            return -1
        
        #faz as demais seleções baseado no conteúdo de lista
        for item in indicador:
            
            if indicador.index(item) != 0:
                try:
                    driver.find_element(By.XPATH, item).click()
                except:
                    print("Erro ao selecionar a opção "+ item)
                    return -1
            
        #clica no botão mostra
        try:
            driver.find_element(By.XPATH, '//input[@name="mostre"]').click()
        except:
            print("Erro ao selecionar o apção Mostra")
            return -1
    
        #carrega o html da página que mostra os dados
        try:
            html = driver.page_source
            soup = BeautifulSoup(html, 'html.parser')
        except: 
            print("Erro ao acessar a página com os dados. Verifique seu acesso à internet e se o site do DATASUS está no ar.")
            return -1
    
        try:
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
            
            #se for o primeiro indicador, obter os códigos e nomes dos municípios
            if lista.index(indicador) == 0:
                codigos = []
                municipios = []
                for l in df[:, 0]: #os 6 primeiros caracteres correspondem ao código, os demais ao nome do município
                    codigos.append(l[0:6])
                    municipios.append(l[7:])
                resultado = pd.DataFrame(list(zip(codigos, municipios)), columns=['IBGE6', 'Municipio'])
                
            dados_atuais = pd.DataFrame(df[:, 1], columns= [indicador[0]])
            dados_atuais = dados_atuais.replace('-', '0').astype(int)
            resultado = pd.concat([resultado, dados_atuais], axis=1)
        except:
            print("Erro ao obter os dados")
            return None
        
        print(indicador[0])
        
    print("Dados datasus obtidos.")
    return resultado 


def Main():
    
    segundo_plano = leExcel(path_populacao)
    segundo_plano.start()
    
    
    resultado = obtem_dados_datasus()
    if resultado.empty:
        print("Erro ao obter os dados do datasus. Verifique a mensagem de erro anterior.")
        return -1
    
    print("Aguardando a importação dos dados da população finalizar.")
    dados_pop = segundo_plano.join()
    
    print("Salvando os dados no arquivo de saída.")
    
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

