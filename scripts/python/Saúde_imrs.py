

import re
import selenium
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException

url = "http://tabnet.saude.mg.gov.br/tabcgi.exe?def/obitos/geralr.def"

driver = webdriver.Chrome("H:/FJP/scripts/python/chromedriver")

chrome_options = webdriver.ChromeOptions()

prefs = {'download.default_directory' : 'C:/Users/Thalles/Documents/Meus documentos/FJP/FJP/pythonProject'}
chrome_options.add_experimental_option('prefs', prefs)
driver = webdriver.Chrome(options=chrome_options)
driver.set_page_load_timeout(60)

driver.get(url)
# linha
driver.find_element_by_xpath('/html/body/center/div/form/div[2]/div/div[1]/select/option[1]').click()


# Coluna
driver.find_element_by_xpath('/html/body/center/div/form/div[2]/div/div[2]/select/option[1]').click()


# Exibir linhas zeradas
driver.find_element_by_xpath('/html/body/center/div/form/div[4]/div[2]/div[1]/div[1]/input[2]').click()

# Periodo
driver.find_element_by_xpath('/html/body/center/div/form/div[3]/div/select/option[2]').click()

# Cid-10
#driver.find_element_by_xpath('//*[@id="fig10"]').click()

click0 = '//*[@id="S10"]/option[1]'
lista = ['//*[@id="S10"]/option[227]',
    '//*[@id="S10"]/option[1584]',
'//*[@id="S10"]/option[1585]',
'//*[@id="S10"]/option[1586]',
'//*[@id="S10"]/option[1587]',
'//*[@id="S10"]/option[1588]',
'//*[@id="S10"]/option[1589]'
]

from bs4 import BeautifulSoup
import numpy
for item in lista:

    driver.find_element_by_xpath('//*[@id="fig10"]').click()
    driver.find_element_by_xpath(click0).click()
    driver.find_element_by_xpath(item).click()
    driver.find_element_by_xpath('/html/body/center/div/form/div[4]/div[2]/div[2]/input[1]').click()
    html = driver.page_source
    
    
    soup = BeautifulSoup(html, 'html.parser')
    name = soup(text=re.compile('CID-10'))

    title = soup.find('b', text = re.compile(ur'CID-10:(.*)', re.DOTALL), attrs = {'class': 'pos'})
    self.response.out.write(str(title.string).decode('utf8'))

    tabdados = soup.select(".tabdados tbody tr td")
    tabdados = list(map(lambda node: node.get_text().strip(), tabdados))

    col_tabdados = soup.select(".tabdados th")
    col_tabdados = list(map(lambda node: node.get_text().strip(), col_tabdados))



    len_tabdados = len(tabdados)
    len_col_tabdados = len(col_tabdados)

    nrow = int(len_tabdados/len_col_tabdados)
    ncol = int(len_col_tabdados)

    df_names = numpy.array(col_tabdados).reshape(1,ncol)
    df = numpy.array(tabdados).reshape(nrow,ncol)

    df = numpy.vstack([df_names, df])

    numpy.savetxt("H:/FJP/scripts/python/teste.csv", df, delimiter=",", fmt='%s')

    driver.back()


