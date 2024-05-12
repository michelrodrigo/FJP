#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(rhandsontable)
library(lubridate)
library(tidyverse)
library("shinyjs")

projetos <- c()

# Define UI for application that draws a histogram
ui <- dashboardPage(skin = "green",

    # Application title
    titulo <- dashboardHeader(title = "Cronograma"),

    # Sidebar with a slider input for number of bins 
    dashboardSidebar(
        sidebarMenu(id = "barra_lateral",
            menuItem("Cadastro", tabName = 'cadastro'),
            menuItem("Visualização", tabName = 'visualizacao')
        )
    ),

        # Show a plot of the generated distribution
    dashboardBody(
        tabItems(
            tabItem(tabName = 'cadastro',
                fluidRow(
                    box( title = "Projeto", status = "primary", solidHeader = TRUE,
                         width = 12,
                         collapsible = FALSE,
                         fluidRow(
                             box(
                                 selectInput(inputId = 'lista_projetos', label = "Projetos Cadastrados", choices = projetos)
                            ),
                            box(
                                 textInput(inputId = 'nome_projeto', label = "Digite o nome do projeto"),
                                 actionButton(inputId = 'novo_projeto', label = "Novo projeto"),
                                 actionButton(inputId = 'deletar_projeto', label = "Deletar projeto", disabled='')
                            )
                         )
                    )
                ),
                fluidRow(
                    box( title = "Cadastro de atividades", status = "primary", solidHeader = TRUE,
                         width = 12,
                         collapsible = FALSE,
                         rHandsontableOutput('hot'),
                         actionButton('addRow', 'Add a Row')
                    )
                )        
            )
        )

    ),
    shinyjs::useShinyjs()      
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    td <- today()
    teste <- c("TD", "IMRS")
    
    meusValores <- reactiveValues()
    
    tasks <- tibble(
        Start = c(''),
        End = c(''),
        Project = c(''),
        Task = c('')
    )
    
    observeEvent(input$novo_projeto, {
        if(!is.null(input$nome_projeto)){
            meusValores$projetos <- c(isolate(meusValores$projetos), isolate(input$nome_projeto))
            updateSelectInput(session, inputId = 'lista_projetos', choices = meusValores$projetos, selected = input$nome_projeto)
            updateTextInput(session, inputId = 'nome_projeto', value = "")
        }
    })
    
    observeEvent(input$deletar_projeto, {
        meusValores$projetos <-  setdiff(meusValores$projetos, input$lista_projetos)
        updateSelectInput(session, inputId = 'lista_projetos', choices = meusValores$projetos)
    })
    
    observeEvent(input$lista_projetos,{
        x <- input$lista_projetos
        
        if(x != ""){
            shinyjs::enable('deletar_projeto')
        }
        
    })
    
   
    
    output$hot <- renderRHandsontable({
        
        req(meusValores$tabela)
        
        rhandsontable(meusValores$tabela, colHeaders = c("Início", "Final", "Projeto", "Atividade")) %>%
           hot_col(col = "Início", type = "date", valign = 'htMiddle') %>%
           hot_col(col = "Final", type = "date", valign = 'htMiddle') %>%
           hot_col(col = "Projeto", type = "dropdown", source = teste, valign = 'htMiddle') %>%
           hot_col(col = "Atividade", valign = 'htMiddle') %>%
           hot_table(highlightCol = TRUE, highlightRow = TRUE)
    })
    
    observeEvent(input$addRow, {
        tasks <- hot_to_r(input$hot)
        tasks[nrow(tasks)+1,] <- NA
        meusValores$tabela <- tasks
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

#https://github.com/AABoyles/ShinyGanttCharts/blob/master/app.R
