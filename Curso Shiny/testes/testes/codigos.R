
library(shiny)
library(shinydashboard)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(),
  
  dashboardBody(a(href = "http://fjp.mg.gov.br/", img(src = "logo_fjp.png", weight = 150, height = 150)),
				 br(),
				 h1("IMRS Demografia"),
				 p("Esse dashboard permite a visualização de dados referentes à dimensão Demografia do IMRS", style = "font-size:16pt"),
				 br(),
				 p("Para acessar a plataforma do IMRS, clique", a("aqui", href="http://imrs.fjp.mg.gov.br/"), ".", style = "color: red; font-size:16pt")
                                 
                    )
                         
                          
                
  
  
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)


#  Exe2 ---------

library(shiny)
library(shinydashboard)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(sidebarMenu(id = 'barra_lateral',
                               menuItem("Indicadores - Tabela", tabName = 'indicadores_tabela'),
                               menuItem("Indicadores - Gráfico", tabName = 'indicadores_grafico'),
                               menuItem("Outras informações", tabName = 'outras_infos'),
                               menuItem("Sobre", tabName = 'sobre')
  )
  ),
  
  dashboardBody(tabItems(tabItem(tabName = 'indicadores_tabela', "Indicadores"),                                 
                         tabItem(tabName = 'indicadores_grafico', "Indicadores"),
                         tabItem(tabName = 'outras_infos', "Outras informações"),
                         tabItem(tabName = 'sobre',
                                 a(href = "http://fjp.mg.gov.br/", img(src = "logo_fjp.png", weight = 150, height = 150)),
                                 br(),
                                 h1("IMRS Demografia"),
                                 p("Esse dashboard permite a visualização de dados referentes à dimensão Demografia do IMRS", style = "font-size:16pt"),
                                 br(),
                                 p("Para acessar a plataforma do IMRS, clique", a("aqui", href="http://imrs.fjp.mg.gov.br/"), ".", style = "color: red; font-size:16pt")
                                 
                         )
  )
  ))

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)

# Exe3 ------------


library(shiny)
library(shinydashboard)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(sidebarMenu(id = 'barra_lateral',
                               menuItem("Indicadores - Tabela", tabName = 'indicadores_tabela'),
                               menuItem("Indicadores - Gráfico", tabName = 'indicadores_grafico'),
                               menuItem("Outras informações", tabName = 'outras_infos'),
                               menuItem("Sobre", tabName = 'sobre')
  )
  ),
  
  dashboardBody(tabItems(tabItem(tabName = 'indicadores_tabela',
                                 fluidRow(
                                   box(width = 12,
                                       column(width = 6,
                                              selectInput(inputId = 'municipios',
                                                          label = "Escolha o município:",
                                                          choices = c("Belo Horizonte", "Betim", "Contagem"))),
                                       column(width = 6,
                                              selectInput(inputId = 'ano_tabela',
                                                          label = "Escolha o ano:",
                                                          choices = c(2019, 2020)))))),
                         tabItem(tabName = 'indicadores_grafico', "Indicadores"),
                         tabItem(tabName = 'outras_infos', "Outras informações"),
                         tabItem(tabName = 'sobre',
                                 a(href = "http://fjp.mg.gov.br/", img(src = "logo_fjp.png", weight = 150, height = 150)),
                                 br(),
                                 h1("IMRS Demografia"),
                                 p("Esse dashboard permite a visualização de dados referentes à dimensão Demografia do IMRS", style = "font-size:16pt"),
                                 br(),
                                 p("Para acessar a plataforma do IMRS, clique", a("aqui", href="http://imrs.fjp.mg.gov.br/"), ".", style = "color: red; font-size:16pt")
                                 
                         )
                         
  )
  )
  
  
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)



# Exe4 -----------

library(shiny)
library(shinydashboard)
library(readxl)


dados <- read_excel("dados_curso1.xlsx") 
dados <- dados |> select(-1)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(sidebarMenu(id = 'barra_lateral',
                               menuItem("Indicadores - Tabela", tabName = 'indicadores_tabela'),
                               menuItem("Indicadores - Gráfico", tabName = 'indicadores_grafico'),
                               menuItem("Outras informações", tabName = 'outras_infos'),
                               menuItem("Sobre", tabName = 'sobre')
  )
  ),
  
  dashboardBody(tabItems(tabItem(tabName = 'indicadores_tabela',
                                 fluidRow(
                                   box(width = 12,
                                       column(width = 4,
                                              selectInput(inputId = 'municipios',
                                                          label = "Escolha o município:",
                                                          choices = unique(dados$MUNICIPIO),
                                                          multiple = TRUE,
                                                          selected = NULL)),
                                       column(width = 4,
                                              selectInput(inputId = 'indicadores',
                                                          label = "Escolha o indicador",
                                                          choices = c("AREA", "D_POPTA", "HOMEMTOT", "MULHERTOT"),
                                                          multiple = TRUE,
                                                          selected = NULL)),
                                       column(width = 4,
                                              selectInput(inputId = 'ano_tabela',
                                                          label = "Escolha o ano:",
                                                          choices = unique(dados$ANO),
                                                          multiple = TRUE)))),
                                 
                                 dataTableOutput(outputId = 'tabela')
                                 
  ),
  tabItem(tabName = 'indicadores_grafico', "Indicadores"),
  tabItem(tabName = 'outras_infos', "Outras informações"),
  tabItem(tabName = 'sobre',
          a(href = "http://fjp.mg.gov.br/", img(src = "logo_fjp.png", weight = 150, height = 150)),
          br(),
          h1("IMRS Demografia"),
          p("Esse dashboard permite a visualização de dados referentes à dimensão Demografia do IMRS", style = "font-size:16pt"),
          br(),
          p("Para acessar a plataforma do IMRS, clique", a("aqui", href="http://imrs.fjp.mg.gov.br/"), ".", style = "color: red; font-size:16pt")
          
  )
  
  )
  )
  
  
)

server <- function(input, output) {
  
  output$tabela <- renderDataTable({
    req(input$indicadores, input$municipios, input$ano_tabela)
    dados |> select(c(MUNICIPIO, ANO, input$indicadores)) |>
      subset(MUNICIPIO %in% input$municipios & ANO %in% input$ano_tabela)
  })
}

shinyApp(ui = ui, server = server)

# tabs -------------------------


library(shiny)
library(shinydashboard)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(sidebarMenu(id = 'barra_lateral',
                               menuItem("Opção 1", tabName = 'opcao1'),
                               menuItem("Opção 2", tabName = 'opcao2')
  )
  ),
  
  dashboardBody(tabItems(tabItem(tabName = 'opcao1', 
                                 tabBox(width = 12,
                                        tabPanel(title = "Aba 1", "Conteúdo da aba 1 da primeira opção do menu"),
                                        tabPanel(title = "Aba 2", "Conteúdo da aba 2 da primeira opção do menu")
                                 )
  ),
  tabItem(tabName = 'opcao2', "Conteúdo da opção 2")
  )
  )
  
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)

# Gráfico 2 ----------

library(highcharter)
library("shinyjs")

h <- highchart() |>
  hc_chart(type = 'column') |>
  hc_title(text = "Total fruit consumption, grouped by gender") |>
  hc_xAxis(categories = c('Apples', 'Oranges', 'Pears', 'Grapes', 'Bananas') ) |>
  hc_yAxis(allowDecimals = FALSE, min = 0, title = "Number of fruits") |>
  hc_add_series(name = "John", data = c(5, 3, 4, 7, 2), stack = 'male') |> 
  hc_add_series(name = "Joe", data = c(3, 4, 4, 2, 5), stack = 'male') |>
  hc_add_series(name = "Jane", data = c(2, 5, 6, 2, 1), stack = 'female') |>
  hc_add_series(name = "Janet", data = c(3, 0, 4, 4, 3), stack = 'female') |>
  hc_plotOptions(column = list(stacking = 'normal')) |>
  hc_tooltip(formatter = JS(paste0( 'function () {
                  return "<b>" + this.x + "</b><br/>" +
                this.series.name + ": " + this.y + "<br/>" +
                "Total: " + this.point.stackTotal;
        }'))) 


h
#https://www.highcharts.com/demo/column-stacked-and-grouped


library(shiny)
library(shinydashboard)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(sidebarMenu(id = 'barra_lateral',
                               menuItem("Indicadores", tabName = 'indicadores'),
                               conditionalPanel(condition = "input.barra_lateral == 'indicadores'",
                                                selectInput(inputId = 'municipios',
                                                            label = "Escolha o município:",
                                                            choices = c("Belo Horizonte", "Betim", "Contagem")),
                                                conditionalPanel(condition = "input.tab_tabela_grafico == 'Tabela'",
                                                                 selectInput(inputId = 'ano_tabela',
                                                                             label = "Escolha o ano:",
                                                                             choices = c(2019, 2020))),
                                                conditionalPanel(condition = "input.tab_tabela_grafico == 'Gráfico'",
                                                                 sliderInput(inputId = 'ano_grafico',
                                                                             label = "Escolha o ano:",
                                                                             min = 2000, max = 2020,
                                                                             value = c(2000, 2020)))),
                               
                               menuItem("Outras informações", tabName = 'outras_infos'),
                               menuItem("Sobre", tabName = 'sobre')
  )
  ),
  
  dashboardBody(tabItems(tabItem(tabName = 'indicadores', 
                                 tabBox(id = 'tab_tabela_grafico',
                                        width = 12,
                                        title = "Tipo de Visualização",
                                        tabPanel(title = "Tabela", "Aqui colocaremos uma tabela"),
                                        tabPanel(title = "Gráfico", "Aqui colocaremos um gráfico"))),
                         tabItem(tabName = 'outras_infos', "Outras informações"),
                         tabItem(tabName = 'sobre',
                                 a(href = "http://fjp.mg.gov.br/", img(src = "logo_fjp.png", weight = 150, height = 150)),
                                 br(),
                                 h1("IMRS Demografia"),
                                 p("Esse dashboard permite a visualização de dados referentes à dimensão Demografia do IMRS", style = "font-size:16pt"),
                                 br(),
                                 p("Para acessar a plataforma do IMRS, clique", a("aqui", href="http://imrs.fjp.mg.gov.br/"), ".", style = "color: red; font-size:16pt")
                                 
                         )
                         
  )
  )
  
  
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)

# widgets ------

library(shiny)
library(shinydashboard)


ui <-  dashboardPage(
  dashboardHeader(title = "Widgets"),
  
  dashboardSidebar(),
  
  dashboardBody(selectInput(inputId = 'input1', 
                            label = "selectInput", 
                            choices = c("a", "b", "c"), 
                            selected = "b", 
                            multiple = TRUE
  ),
  checkboxInput(inputId = 'input2',
                label = "checkbox",
                value = TRUE),
  checkboxGroupInput(inputId = 'input3',
                     label = "checkboxGroup",
                     choices = c("Opção 1", "Opção 2")
  ),
  radioButtons(inputId = 'input4',
               label = "radioButtons",
               choices = c("Opção 1", "Opção 2")
  ),
  dateInput(inputId = 'input5',
            label = "dateInput",
            format = "yyyy-mm-dd"
  ),
  dateRangeInput(inputId = 'input6',
                 label = "dateRangeInput",
                 min = "2022-01-01", 
                 format = "dd-mm-yyyy"),
  fileInput(inputId = 'input7',
            label = "fileInput"
  ),
  helpText("Nota para dar alguma informação adicional."),
  numericInput(inputId = 'input8',
               label = "numericInput",
               value = 0,
               min = -10,
               max = 10),
  sliderInput(inputId = 'input9',
              label = "sliderInput",
              min = 1,
              max = 100,
              value = 5
  ),
  textInput(inputId = 'input10',
            label = "textInput", value = "Digite uma palavra"),
  actionButton(inputId = 'input11',
               label = "actionButton")
  
  
  
  )
  
  
  
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)

# Gráfico -------

library(shiny)
library(shinydashboard)
library(readxl)
library(highcharter)


dados <- read_excel("dados_curso1.xlsx") 
dados <- dados |> select(-1)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(),
  
  
  
  dashboardBody(fluidRow(
    box(width = 12,
        column(width = 4,
               selectInput(inputId = 'municipios',
                           label = "Escolha o município:",
                           choices = unique(dados$MUNICIPIO),
                           multiple = TRUE,
                           selected = NULL)),
        column(width = 4,
               selectInput(inputId = 'indicadores',
                           label = "Escolha o indicador",
                           choices = c("AREA", "D_POPTA", "HOMEMTOT", "MULHERTOT"),
                           multiple = FALSE,
                           selected = NULL)),
        column(width = 4,
               sliderInput(inputId = 'ano_grafico',
                           label = "Escolha o ano:",
                           min = 2000,
                           max = 2020,
                           value = c(2000, 2020)
               )))),
    
    highchartOutput(outputId ='grafico'))
  
)

server <- function(input, output) {
  
  output$grafico <- renderHighchart({
    
    req(input$municipios)
    req(input$indicadores)
    
    dados_final <- lapply(input$municipios, function(x){
      dados_selecionados <- dados |>  
        subset(MUNICIPIO %in% x & (ANO >= input$ano_grafico[1]) & (ANO <= input$ano_grafico[2])) |>  
        select(c(MUNICIPIO, ANO, input$indicadores)) 
      colnames(dados_selecionados) <- c("MUNICIPIO", "ANO", "INDICADOR")
      
      dados_final <- data.frame(x = dados_selecionados$ANO, 
                                y = dados_selecionados$INDICADOR)
    })
    
    
    h <- highchart()
    
    
    for (k in 1:length(dados_final)) {
      h <- h |> 
        hc_add_series(data = dados_final[[k]], name = input$municipios[k])
    }
    
    h
    
  })
  
}

shinyApp(ui = ui, server = server)

# Exe 5------------------

library(shiny)
library(shinydashboard)
library(readxl)


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

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(sidebarMenu(id = 'barra_lateral',
                               menuItem("Indicadores - Tabela", tabName = 'indicadores_tabela'),
                               menuItem("Indicadores - Gráfico", tabName = 'indicadores_grafico'),
                               menuItem("Outras informações", tabName = 'outras_infos'),
                               menuItem("Sobre", tabName = 'sobre')
  )
  ),
  
  dashboardBody(tabItems(tabItem(tabName = 'indicadores_tabela',
                                 fluidRow(
                                   box(width = 12,
                                       column(width = 4,
                                              selectInput(inputId = 'municipios',
                                                          label = "Escolha o município:",
                                                          choices = unique(dados$MUNICIPIO),
                                                          multiple = TRUE,
                                                          selected = NULL)),
                                       column(width = 4,
                                              selectInput(inputId = 'indicadores',
                                                          label = "Escolha o indicador",
                                                          choices = c("AREA", "D_POPTA", "HOMEMTOT", "MULHERTOT"),
                                                          multiple = TRUE,
                                                          selected = NULL)),
                                       column(width = 4,
                                              selectInput(inputId = 'ano_tabela',
                                                          label = "Escolha o ano:",
                                                          choices = unique(dados$ANO),
                                                          multiple = TRUE)))),
                                 
                                 dataTableOutput(outputId = 'tabela')
                                 
  ),
  tabItem(tabName = 'indicadores_grafico', 
          fluidRow(
            box(width = 12,
                column(width = 4,
                       selectInput(inputId = 'municipios_grafico',
                                   label = "Escolha o município:",
                                   choices = unique(dados$MUNICIPIO),
                                   multiple = TRUE,
                                   selected = NULL)),
                column(width = 4,
                       selectInput(inputId = 'indicadores_grafico',
                                   label = "Escolha o indicador",
                                   choices = c("AREA", "D_POPTA", "HOMEMTOT", "MULHERTOT"),
                                   multiple = FALSE,
                                   selected = "D_POPTA")),
                column(width = 4,
                       sliderInput(inputId = 'ano_grafico',
                                   label = "Escolha o intervalo:",
                                   min = min(dados$ANO),
                                   max = max(dados$ANO),
                                   value = c(min(dados$ANO), max(dados$ANO)))))),
          
          fluidRow(
            box(width = 12,
                highchartOutput(outputId = 'grafico')
            ))),
  tabItem(tabName = 'outras_infos', "Outras informações"),
  tabItem(tabName = 'sobre',
          a(href = "http://fjp.mg.gov.br/", img(src = "logo_fjp.png", weight = 150, height = 150)),
          br(),
          h1("IMRS Demografia"),
          p("Esse dashboard permite a visualização de dados referentes à dimensão Demografia do IMRS", style = "font-size:16pt"),
          br(),
          p("Para acessar a plataforma do IMRS, clique", a("aqui", href="http://imrs.fjp.mg.gov.br/"), ".", style = "color: red; font-size:16pt")
          
  )
  
  )
  )
  
  
)

server <- function(input, output) {
  
  output$tabela <- renderDataTable({
    req(input$indicadores, input$municipios, input$ano_tabela)
    dados |> select(c(MUNICIPIO, ANO, input$indicadores)) |>
      subset(MUNICIPIO %in% input$municipios & ANO %in% input$ano_tabela)
  })
  
  output$grafico <- renderHighchart({
    
    req(input$municipios_grafico)
    req(input$indicadores_grafico)
    
    dados_final <- lapply(input$municipios_grafico, function(x){
      dados_selecionados <- dados |>  
        subset(MUNICIPIO %in% x & (ANO >= input$ano_grafico[1]) & (ANO <= input$ano_grafico[2])) |>  
        select(c(MUNICIPIO, ANO, input$indicadores_grafico)) 
      colnames(dados_selecionados) <- c("MUNICIPIO", "ANO", "INDICADOR")
      
      dados <- data.frame(x = dados_selecionados$ANO, 
                          y = dados_selecionados$INDICADOR)
      
    })  
    
    h <- highchart() |>
      
      hc_xAxis(title = list(text = "Ano"), allowDecimals = FALSE) |>
      hc_chart(type = "line") |>
      hc_exporting(enabled = T, fallbackToExportServer = F, 
                   menuItems = export)  |>
      hc_yAxis(title = list(text = "Valor do indicador ")) |>
      hc_title(text = paste("Indicador: ", input$indicadores_grafico))
    
    
    for (k in 1:length(dados_final)) {
      h <- h |> 
        hc_add_series(data = dados_final[[k]], name = input$municipios_grafico[k])
    }
    
    h
    
  })
}

shinyApp(ui = ui, server = server)

# exemplo fórmula-----------

library(shiny)
library(shinydashboard)
library(readxl)
library(tidyverse)


dados <- read_excel("dados_curso1.xlsx") 
dados <- dados |> select(-1)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(),
  
  dashboardBody(selectInput(inputId = 'municipios',
                            label = "Escolha o município:",
                            choices = unique(dados$MUNICIPIO),
                            multiple = TRUE,
                            selected = NULL),
                
                
                span("Média da área dos municípios: ", textOutput(outputId = 'media_area', inline = TRUE), "km²", style='font-size:24px;'),
                br(),
                br(), 
                withMathJax(span(uiOutput("formula"), style='font-size:24px;'))
  )
)

server <- function(input, output) {
  
  output$media_area <- renderText({
    dados_selecionados <- dados |> select(MUNICIPIO, AREA, ANO) |>
      subset(ANO == 2020 & dados$MUNICIPIO %in% input$municipios)
    
    media <- sum(dados_selecionados$AREA) / length(input$municipios)
    as.character(format(round(media, 2), nsmall = 2, big.mark = ".", decimal.mark = ","))
  })
  
  output$formula <- renderUI({
    my_calculated_value <- 5
    withMathJax(paste0("Exemplo de fórmula: $$\\sum_{n=1}^k \\frac{1}{n} ≻ \\int_1^{k+1} \\frac{1}{x} dx = \\ln(k+1)", my_calculated_value,"$$"))
  })
}

shinyApp(ui = ui, server = server)

# Exemplo botão ------------

library(shiny)
library(shinydashboard)
library(readxl)
library(tidyverse)


dados <- read_excel("dados_curso1.xlsx") 
dados <- dados |> select(-1)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(),
  
  dashboardBody(numericInput(inputId = 'num_municipios', label = "Digite o número de municípios", value = 1),
                actionButton(inputId = 'sorteia_municipios', label = "Sortear"),
                textOutput(outputId = 'municipios_sorteados', inline = FALSE))
)

server <- function(input, output) {
  
  output$municipios_sorteados <- renderText({
    mun <- sample(dados$MUNICIPIO, input$num_municipios)
    paste(mun, collapse = ", ")
    
  })
  
}

shinyApp(ui = ui, server = server)

# Exemplo observeEvent ---------
library(shiny)
library(shinydashboard)
library(readxl)
library(tidyverse)


dados <- read_excel("dados_curso1.xlsx") 
dados <- dados |> select(-1)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(),
  
  dashboardBody(numericInput(inputId = 'num_municipios', label = "Digite o número de municípios", value = 1),
                textOutput(outputId = 'municipios_sorteados', inline = FALSE),
                actionButton(inputId = 'atualiza', label = "Atualizar"),
                checkboxGroupInput(inputId = 'seletor', label = "Escolha o município", choices = NULL))
)

server <- function(input, output) {
  
  meus_dados <- reactiveValues()
  
  
  output$municipios_sorteados <- renderText({
    mun <- sample(dados$MUNICIPIO, input$num_municipios)
    meus_dados$mun <- mun
    paste(mun, collapse = ", ")
    
    
  })
  
  observeEvent(input$atualiza, {
    updateCheckboxGroupInput(inputId = 'seletor', choices = meus_dados$mun)
  })
  
}

shinyApp(ui = ui, server = server)

# Exe 6 ----------
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

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(sidebarMenu(id = 'barra_lateral',
                               menuItem("Indicadores - Tabela", tabName = 'indicadores_tabela'),
                               menuItem("Indicadores - Gráfico", tabName = 'indicadores_grafico'),
                               menuItem("Outras informações", tabName = 'outras_infos'),
                               menuItem("Sobre", tabName = 'sobre')
  )
  ),
  
  dashboardBody(tabItems(tabItem(tabName = 'indicadores_tabela',
                                 fluidRow(
                                   box(width = 12,
                                       column(width = 4,
                                              selectInput(inputId = 'municipios',
                                                          label = "Escolha o município:",
                                                          choices = unique(dados$MUNICIPIO),
                                                          multiple = TRUE,
                                                          selected = NULL)),
                                       column(width = 4,
                                              selectInput(inputId = 'indicadores',
                                                          label = "Escolha o indicador",
                                                          choices = c("AREA", "D_POPTA", "HOMEMTOT", "MULHERTOT"),
                                                          multiple = TRUE,
                                                          selected = NULL)),
                                       column(width = 4,
                                              selectInput(inputId = 'ano_tabela',
                                                          label = "Escolha o ano:",
                                                          choices = unique(dados$ANO),
                                                          multiple = TRUE)))),
                                 
                                 dataTableOutput(outputId = 'tabela')
                                 
  ),
  tabItem(tabName = 'indicadores_grafico', 
          fluidRow(
            box(width = 12,
                column(width = 4,
                       selectInput(inputId = 'municipios_grafico',
                                   label = "Escolha o município:",
                                   choices = unique(dados$MUNICIPIO),
                                   multiple = TRUE,
                                   selected = NULL)),
                column(width = 4,
                       selectInput(inputId = 'indicadores_grafico',
                                   label = "Escolha o indicador",
                                   choices = c("AREA", "D_POPTA", "HOMEMTOT", "MULHERTOT"),
                                   multiple = FALSE,
                                   selected = "D_POPTA")),
                column(width = 4,
                       sliderInput(inputId = 'ano_grafico',
                                   label = "Escolha o intervalo:",
                                   min = min(dados$ANO),
                                   max = max(dados$ANO),
                                   value = c(min(dados$ANO), max(dados$ANO)))))),
          
          fluidRow(
            box(width = 12,
                highchartOutput(outputId = 'grafico')
            ))),
  tabItem(tabName = 'outras_infos', 
          box( title = NULL,
               status = "success",
               solidHeader = TRUE,
               width = 12,
               collapsible = TRUE,
               collapsed = FALSE,
               numericInput(inputId = 'num_municipios', label = "Digite o número de municípios", value = 1),
               actionButton(inputId = 'sorteia_municipios', label = "Sortear"),
               br(),
               textOutput(outputId = 'municipios_sorteados', inline = FALSE),
               br(),
               actionButton(inputId = 'atualizar_municipios', label = "Atualizar opções"),
               br(),
               checkboxGroupInput(inputId = 'selecao_municipios', label = "Escolha os municípios", choices = NULL),
               br(),
               span("População total: ", textOutput(outputId = 'populacao')))
          
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
  )
  
  
)

server <- function(input, output) {
  
  output$tabela <- renderDataTable({
    req(input$indicadores, input$municipios, input$ano_tabela)
    dados |> select(c(MUNICIPIO, ANO, input$indicadores)) |>
      subset(MUNICIPIO %in% input$municipios & ANO %in% input$ano_tabela)
  })
  
  output$grafico <- renderHighchart({
    
    req(input$municipios_grafico)
    req(input$indicadores_grafico)
    
    dados_final <- lapply(input$municipios_grafico, function(x){
      dados_selecionados <- dados |>  
        subset(MUNICIPIO %in% x & (ANO >= input$ano_grafico[1]) & (ANO <= input$ano_grafico[2])) |>  
        select(c(MUNICIPIO, ANO, input$indicadores_grafico)) 
      colnames(dados_selecionados) <- c("MUNICIPIO", "ANO", "INDICADOR")
      
      dados <- data.frame(x = dados_selecionados$ANO, 
                          y = dados_selecionados$INDICADOR)
      
    })  
    
    h <- highchart() |>
      
      hc_xAxis(title = list(text = "Ano"), allowDecimals = FALSE) |>
      hc_chart(type = "line") |>
      hc_exporting(enabled = T, fallbackToExportServer = F, 
                   menuItems = export)  |>
      hc_yAxis(title = list(text = "Valor do indicador ")) |>
      hc_title(text = paste("Indicador: ", input$indicadores_grafico))
    
    
    for (k in 1:length(dados_final)) {
      h <- h |> 
        hc_add_series(data = dados_final[[k]], name = input$municipios_grafico[k])
    }
    
    h
    
  })
  
  meus_dados <- reactiveValues()
  
  
  output$municipios_sorteados <- renderText({
    input$sorteia_municipios
    mun <- isolate(sample(unique(dados$MUNICIPIO), input$num_municipios))
    meus_dados$mun <- mun
    paste(mun, collapse = ", ")
    
    
  })
  
  observeEvent(input$atualizar_municipios, {
    updateCheckboxGroupInput(inputId = 'selecao_municipios', choices = meus_dados$mun)
  })
  
  output$populacao <- renderText({
    dados_selecionados <- dados |> subset(dados$MUNICIPIO %in% input$selecao_municipios & ANO == 2020)
    sum(dados_selecionados$D_POPTA)
  })
}

shinyApp(ui = ui, server = server)

# Exemplo alerta ----------
library(shiny)
library(shinydashboard)
library(readxl)
library(tidyverse)
library(shinyalert)


dados <- read_excel("dados_curso1.xlsx") 
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

