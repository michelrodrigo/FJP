import time
import selenium
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException
import time
from bs4 import BeautifulSoup
import numpy
import csv



url = "http://tabnet.datasus.gov.br/cgi/dhdat.exe?bd_pni/cpnibr.def"

driver = webdriver.Chrome("H:/FJP/scripts/python/chromedriver")

chrome_options = webdriver.ChromeOptions()

prefs = {'download.default_directory': 'D:\Downloads'}
chrome_options.add_experimental_option('prefs', prefs)
driver = webdriver.Chrome(options=chrome_options)
driver.set_page_load_timeout(60)

driver.get(url)

# linha
driver.find_element_by_xpath('//*[@id="L"]/option[3]').click()

# Coluna
driver.find_element_by_xpath('//*[@id="C"]/option[6]').click()

# medidas
driver.find_element_by_xpath('//*[@id="I"]/option[1]').click()

# Periodo
driver.find_element_by_xpath('//*[@id="A"]/option[2]').click()

# unidade da federação
driver.find_element_by_xpath('//*[@id="fig2"]').click()
driver.find_element_by_xpath('//*[@id="S2"]/option[1]').click()
driver.find_element_by_xpath('//*[@id="S2"]/option[14]').click()


driver.find_element_by_xpath('//*[@id="I"]/option[1]').click()

driver.find_element_by_xpath('//*[@id="fig16"]').click()

driver.find_element_by_xpath('//*[@id="S16"]/option[1]').click()
driver.find_element_by_xpath('//*[@id="S16"]/option[7]').click()
driver.find_element_by_xpath('/html/body/center[2]/div/form/div[3]/div[2]/div[3]/input[1]').click()
html = driver.page_source
soup = BeautifulSoup(html, 'html.parser')

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from urllib.request import urlretrieve
from urllib.parse import urljoin




abas = driver.window_handles
driver.switch_to.window(abas[1])
#downloadcsv = driver.find_element_by_xpath("/html/body/center[2]/div[2]/table/tbody/tr/td[2]/a").click()
WebDriverWait(driver, 20).until(EC.element_to_be_clickable((By.XPATH, "/html/body/center[2]/div[2]/table/tbody/tr/td[2]/a"))).click()



