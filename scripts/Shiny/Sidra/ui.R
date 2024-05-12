
library("shiny")
library("sidrar")

ui <- fluidPage(
  
  
  
  
  numericInput(inputId = "tabela",
               label = "Digite o número da tabela",
               value = 0),
  
  actionButton(inputId = "go",
               label = "Update"),
  
  actionButton(inputId = "api",
               label = "Gerar API"),
  
  actionButton(inputId = "add_territorio",
               label = "Adicionar"),
  
  textOutput("string_api"),
  
  textOutput("titulo_tabela"),
  
  checkboxGroupInput(inputId = "periodos_consulta",
                     label = "Escolha os períodos:",
                     choiceNames = c("Todos"),
                     choiceValues = c(0)),
  
  
  checkboxGroupInput(inputId = "Variaveis_consulta",
                     label = "Escolha as variáveis:",
                     choiceNames = c("Todas"),
                     choiceValues = c(0)),
  
  selectInput(inputId = "territorios_consulta",
              label = "Escolha os níveis territoriais:",
              choices = c("Escolha")
              
  ),
  
  
  
  
)