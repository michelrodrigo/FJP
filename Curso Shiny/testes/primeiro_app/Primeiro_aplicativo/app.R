library(shiny)
library(shinydashboard)
library(readxl)
library(tidyverse)
library(shinyalert)


dados <- read_excel("www\\dados_curso1.xlsx") 
dados <- dados |> select(-1)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(),
  
  dashboardBody(numericInput(inputId = 'num_municipios', label = "Digite o número de municípios (1-10)", value = 1),
                actionButton(inputId = 'sorteia_municipios', label = "Sortear"),
                textOutput(outputId = 'municipios_sorteados', inline = FALSE))
)

server <- function(input, output) {
  
  output$municipios_sorteados <- renderText({
    
    num <- isolate(input$num_municipios)
    
    input$sorteia_municipios
    
    if(num < 1 | num > 10){
      shinyalert(title = "Erro", text = "O número de municípios deve ser um número entre 1 e 10.")
    }
    else{
      mun <- isolate(sample(unique(dados$MUNICIPIO), num))
      paste(mun, collapse = ", ")
    }
    
  })
  
  
}

shinyApp(ui = ui, server = server)