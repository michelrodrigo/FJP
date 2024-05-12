library(shiny)
library(shinydashboard)
library(readxl)
library(tidyverse)
library(highcharter)

dados <- read_excel("dados_curso1.xlsx") 
dados <- dados |> select(-1)

#função para exportação de imagens
export <- list(
  list(text="PNG",
       onclick=JS("function () {
                this.exportChartLocal(); }")),
  list(text="JPEG",
       onclick=JS("function () {
                this.exportChartLocal({ type: 'image/jpeg' }); }"))
  
)