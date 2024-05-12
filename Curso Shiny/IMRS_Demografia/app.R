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
library(highcharter)
library("ggplot2")
library(readxl)
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

#dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
#setwd(dir)

dados_pop <- read_excel("IMRS2021 - BASE DEMOGRAFIA 2000 a 2020.xlsx")
municipio_codigo <- as_tibble(read_excel("lista municipios FJP.xlsx")) 
colnames(municipio_codigo) <- c("MUNICIPIO", "IBGE6")
dados_pop <- left_join(dados_pop, municipio_codigo, by="IBGE6")
dados_pop <- dados_pop |> select("MUNICIPIO", "IBGE6", everything())
drops <- c("IBGE7", "CHAVE")
dados_pop <- dados_pop[ , !(names(dados_pop) %in% drops)]
#dados_pop$MUNICIPIO

opcoes_indicadores <- colnames(dados_pop[-c(1, 2, 3)])

#dados_pop_curso <- dados_pop |> select(c("MUNICIPIO", "ANO", "AREA", "D_POPTA", "HOMEMTOT", "MULHERTOT")) 
#write.xlsx(dados_pop_curso, "dados_curso1.xlsx")
            


# Define UI for application that draws a histogram
ui <- dashboardPage(skin = "green",
                    
                    # Application title
                    titulo <- dashboardHeader(title = "IMRS Demografia"),
                    
                    # Sidebar with a slider input for number of bins 
                    dashboardSidebar(
                      sidebarMenu(id = "barra_lateral",
                                  menuItem("Municípios", tabName = 'municipios'),
                                  conditionalPanel(condition = "input.barra_lateral == 'municipios'",
                                                   
                                                   selectizeInput(inputId = 'selecao_municipio', label = "Selecione o(s) município(s)", choices = unique(dados_pop$MUNICIPIO), selected = NULL, multiple = TRUE,
                                                                  options = NULL),
                                                   
                                                   
                                                   conditionalPanel(condition = "input.tab_tabela_grafico == 'Tabela'",
                                                                    selectizeInput(inputId = 'selecao_indicador_tabela', label = "Selecione o indicador", choices = NULL, selected = NULL, multiple = TRUE,
                                                                                   options = NULL),
                                                                    selectizeInput(inputId = 'selecao_ano', label = "Selecione o ano", choices = NULL, selected = NULL, multiple = TRUE,
                                                                                   options = NULL)),
                                                   conditionalPanel(condition = "input.tab_tabela_grafico == 'Gráfico'",
                                                                    selectInput(inputId = 'selecao_indicador_grafico', label = "Selecione o indicador", choices = opcoes_indicadores, selected = "D_POPTA", multiple = FALSE,
                                                                    ),
                                                                    sliderInput(inputId = 'selecao_anos', label = "Selecione os anos", min = min(unique(dados_pop$ANO)), max = max(unique(dados_pop$ANO)), 
                                                                                value = c(min(unique(dados_pop$ANO)), max(unique(dados_pop$ANO)))))),
                                  menuItem("Outros indicadores", tabName = 'outros'),
                                  menuItem("Sobre", tabName = 'sobre')
                      )
                    ),
                    
                    # Show a plot of the generated distribution
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = 'municipios',
                                fluidRow(
                                  tabBox(id = 'tab_tabela_grafico',
                                         title = "Tipo de visualização", 
                                         width = 12,
                                         tabPanel(title = "Tabela", 
                                                  dataTableOutput(outputId = 'tabela')), 
                                         tabPanel(title = "Gráfico",
                                                  radioButtons(inputId = 'tipo_visualizacao', label = "Tipo de Gráfico",
                                                               choices = c("Highchart", "GGplot")),
                                                  fluidRow(
                                                    conditionalPanel(condition = "input.tipo_visualizacao == 'Highchart'",
                                                                     box(highchartOutput(outputId = 'grafico_hi'), width = 12)),
                                                    conditionalPanel(condition = "input.tipo_visualizacao == 'GGplot'",
                                                                     box(plotOutput(outputId = 'grafico_ggplot'), width = 12))
                                                  )
                                         )
                                  )
                                )
                        ),
                        
                        tabItem(tabName = 'outros',
                                fluidRow(
                                  tabBox(id = 'tab_estado_municipio',
                                         title = NULL, 
                                         width = 12,
                                         tabPanel(title = "Estado",
                                                  fluidRow(
                                                    box(
                                                      title = "Médias",
                                                      status = "primary",
                                                      solidHeader = TRUE,
                                                      width = 8,
                                                      collapsible = TRUE,
                                                      collapsed = FALSE,
                                                      
                                                      "Média da área dos municípios: ", textOutput(outputId = 'media_area', inline = TRUE), "km²",
                                                      br(),
                                                      "Média da população dos municípios: ", textOutput(outputId = 'media_pop', inline = TRUE), "pessoas",
                                                    )
                                                  ),
                                                  fluidRow(
                                                    box(
                                                      title = "Totais",
                                                      status = "primary",
                                                      solidHeader = TRUE,
                                                      width = 12,
                                                      collapsible = TRUE,
                                                      collapsed = FALSE,
                                                      
                                                      "Total da área do estado: ", textOutput(outputId = 'total_area', inline = TRUE), "km²",
                                                      br(),
                                                      "Total da população do estado: ", textOutput(outputId = 'total_pop', inline = TRUE), "pessoas",
                                                    )
                                                  )
                                         ),
                                         tabPanel(title = "Município",
                                                  fluidRow(
                                                    box( title = NULL,
                                                         status = "success",
                                                         solidHeader = TRUE,
                                                         width = 12,
                                                         collapsible = TRUE,
                                                         collapsed = FALSE,
                                                         numericInput(inputId = 'num_municipios', label = "Digite o número de municípios", value = 1),
                                                         actionButton(inputId = 'sorteia_municipios', label = "Sortear"),
                                                         textOutput(outputId = 'municipios_sorteados', inline = FALSE),
                                                         actionButton(inputId = 'atualizar_municipios', label = "Atualizar opções"),
                                                         
                                                    )
                                                  ),
                                                  fluidRow(
                                                    box(
                                                      title = NULL,
                                                      status = "info",
                                                      solidHeader = TRUE,
                                                      width = 12,
                                                      collapsible = TRUE,
                                                      collapsed = FALSE,
                                                      checkboxGroupInput(inputId = 'selecao_municipios', label = "Selecione os municípios", choices = NULL ),
                                                      "População: ",
                                                      radioButtons(inputId = 'homem_mulher', label = "escolha", choices = c("Homem", "Mulher", "Todos"), selected = "Todos"),
                                                      textOutput(outputId = 'pop_homem_mulher', inline = TRUE), "mil habitantes"
                                                    )
                                                  )
                                                  
                                                  
                                         )
                                  )
                                )
                                
                        ),
                        tabItem(tabName = 'sobre',
                                a(href = "http://fjp.mg.gov.br/", img(src = "logo_fjp.png", weight = 150, height = 150)),
                                br(),
                                h1("IMRS Demografia"),
                                p("Esse dashboard permite a visualização de dados referentes à dimensão Demografia do IMRS", style = "font-size:16pt"),
                                br(),
                                p("Para acessar a plataforma do IMRS, clique", a("aqui", href="http://imrs.fjp.mg.gov.br/"), ".", style = "color: red; font-size:16pt")
                        )
                        
                      )
                      
                    ),
)
                    

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
  #updateSelectizeInput(session, 'selecao_municipio', choices = unique(dados_pop$MUNICIPIO), server = TRUE)
  updateSelectizeInput(session, 'selecao_indicador_tabela', choices = opcoes_indicadores, server = TRUE)
  #updateSelectInput(session, 'selecao_indicador_grafico', choices = opcoes_indicadores, selected = NULL)
  updateSelectizeInput(session, 'selecao_ano', choices = unique(dados_pop$ANO), server = TRUE)
  
    
  output$tabela <- renderDataTable({

    tab <- dados_pop |> 
      select(c("MUNICIPIO", "ANO", "IBGE6", input$selecao_indicador_tabela)) |>
      filter(MUNICIPIO %in% input$selecao_municipio & ANO %in% input$selecao_ano)
    
  })
  
  output$grafico_hi <- renderHighchart({
    
    req(input$selecao_municipio)
    req(input$selecao_indicador_grafico)
    
      dados <- lapply(input$selecao_municipio, function(x){
                      dados <- dados_pop |>  
                              subset(MUNICIPIO %in% x & (ANO >= input$selecao_anos[1]) & (ANO <= input$selecao_anos[2])) |>  
                              select(c(MUNICIPIO, ANO, input$selecao_indicador_grafico)) 
                      colnames(dados) <- c("MUNICIPIO", "ANO", "INDICADOR")
                     
                      dados <- data.frame(x = dados$ANO, 
                                      y = dados$INDICADOR)
                
                      
                })  
      
      h <- highchart() |>
            #hc_size(width = 600, height = 400) |>
            hc_xAxis(title = list(text = "Ano"), allowDecimals = FALSE) |>
            hc_exporting(enabled = T, fallbackToExportServer = F, 
                         menuItems = export)  |>
           hc_chart(type = "line") |>
           hc_yAxis(title = list(text = "Valor do indicador ")) |>
           hc_title(text = paste("Indicador: ", input$selecao_indicador_grafico))
          
          
      for (k in 1:length(dados)) {
        h <- h |> 
          hc_add_series(data = dados[[k]], name = input$selecao_municipio[k])
      }
      
      h
      
  })
  
  valores <- reactiveValues()
  
  output$municipios_sorteados <- renderText({
    input$sorteia_municipios
    
    num <- isolate(input$num_municipios)
    
    if(num > 10 | num < 1){
      shinyalert("Erro!", "O número de municípios deve estar entre 1 e 10", type = "error")
    }else{
      valores$mun <- sample(dados_pop$MUNICIPIO, num)
    
      paste(valores$mun, collapse = ", ")
    }
    
  })
  
  observeEvent(input$atualizar_municipios, {
    updateCheckboxGroupInput(session, inputId = 'selecao_municipios', choices = valores$mun )
  })
  
  output$pop_homem_mulher <- renderText({
    dados <- dados_pop |> subset(ANO == 2020 & MUNICIPIO %in% input$selecao_municipios) |> select(MUNICIPIO, HOMEMTOT, MULHERTOT)
    if(input$homem_mulher == "Homem"){
      sum(dados$HOMEMTOT)
    }else if(input$homem_mulher == "Mulher"){
      sum(dados$MULHERTOT)
    }else{
      sum(sum(dados$MULHERTOT) + sum(dados$HOMEMTOT))
    }
    
    
  })
  
  
  
  
  
  selected <- reactive({
    dados <- dados_pop |>  
      subset(MUNICIPIO %in% input$selecao_municipio & (ANO >= input$selecao_anos[1]) & (ANO <= input$selecao_anos[2])) |>  
      select(c(MUNICIPIO, ANO, input$selecao_indicador_grafico)) 
    colnames(dados) <- c("MUNICIPIO", "ANO", "INDICADOR")
    dados <- data.frame(dados)
  })
  
  output$grafico_ggplot <- renderPlot({
    
     
      ggplot(selected(), aes(x = ANO, y = INDICADOR, colour = MUNICIPIO )) +
        geom_point(size = 3) +
        geom_line(size = 1)+
        guides(colour = guide_legend(title=NULL))+
        labs(title = paste("Indicador: ", input$selecao_indicador_grafico), 
             x = "Ano", y = "Valor do indicador")
      
    
  })
  
  output$media_area <- renderText({
    dados <- dados_pop |> subset(ANO == 2020)
    media <- sum(dados$AREA)/ length(unique(dados$MUNICIPIO))
  })
  
  output$media_pop <- renderText({
    dados <- dados_pop |> subset(ANO == 2020)
    media <- sum(dados$D_POPTA)/ length(unique(dados$MUNICIPIO))
  })
  
  output$total_area <- renderText({
    dados <- dados_pop |> subset(ANO == 2020)
    media <- sum(dados$AREA)
  })
  
  output$total_pop <- renderText({
    dados <- dados_pop |> subset(ANO == 2020)
    media <- sum(dados$D_POPTA)
  })
  
    
}

# Run the application 
shinyApp(ui = ui, server = server)

#https://github.com/AABoyles/ShinyGanttCharts/blob/master/app.R
