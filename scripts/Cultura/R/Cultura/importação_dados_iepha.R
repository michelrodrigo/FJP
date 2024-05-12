

library("pdftools")
library("dplyr")
library("tidyverse")

dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir)

dados_iepha <- readxl::read_excel("iepha_2021.xlsx", sheet =1)

dados_iepha <- dados_iepha %>% select(c(1, 2, 3, 4, 20, 21, 24, 32, 33))   #seleciona as colunas relevantes


colnames(dados_iepha) <- c("MUNICÍPIO", 
                           "SOMATÓRIO PARA CÁLCULO DE PONTUAÇÃO PELOS TOMBAMENTOS",
                           "PROTEÇÃO MUNICIPAL calculada com base no",
                           "PONTUAÇÃO POLÍTICA CULTURAL", 
                           "PONTUAÇÃO INVESTIMENTOS E DESPESAS",
                           "PONTUAÇÃO INVENTÁRIO", 
                           "PONTUAÇÃO EDUCAÇÃO e DIFUSÃO", 
                           "PONTUAÇÃO FINAL TOMBAMENTOS", 
                           "PONTUAÇÃO FINAL REGISTROS")

# remove as linhas desnecessárias  
dados_iepha <- dados_iepha[-c(1:5), ]   
dados_iepha <- subset(dados_iepha, MUNICÍPIO != 'A')

numeros_municipios <-  as.integer(sapply(dados_iepha$MUNICÍPIO, substr, 1, 3))
dados_iepha <- dados_iepha %>% mutate(MUNICÍPIO = sapply(dados_iepha$MUNICÍPIO, substr, 5, 50)) %>%
  mutate(numero = numeros_municipios, .before = MUNICÍPIO)
                      