
library(shiny)
library(shinydashboard)
library(rhandsontable)
library(lubridate)
library(tidyverse)
library("shinyjs")
library(highcharter)
library("ggplot2")
library("readxl")
library(shinyalert)


#função para exportação de imagens
export <- list(
  list(text="PNG",
       onclick=JS("function () {
                this.exportChartLocal(); }")),
  list(text="JPEG",
       onclick=JS("function () {
                this.exportChartLocal({ type: 'image/jpeg' }); }"))
  
)

dados_pop <- read_excel("IMRS2021 - BASE DEMOGRAFIA 2000 a 2020.xlsx")
municipio_codigo <- as_tibble(readxl::read_excel("lista municipios FJP.xlsx")) 
colnames(municipio_codigo) <- c("MUNICÍPIO", "IBGE6")
dados_pop <- left_join(dados_pop, municipio_codigo, by="IBGE6")
dados_pop <- dados_pop |> select("MUNICÍPIO", "IBGE6", everything())
drops <- c("IBGE7", "CHAVE")
dados_pop <- dados_pop[ , !(names(dados_pop) %in% drops)]

opcoes_indicadores <- colnames(dados_pop[-c(1, 2, 3)])

#dados_pop_curso <- dados_pop |> select(c("MUNICÍPIO", "ANO", "AREA", "D_POPTA", "HOMEMTOT", "MULHERTOT")) 
#write.xlsx(dados_pop_curso, "dados_curso1.xlsx")
