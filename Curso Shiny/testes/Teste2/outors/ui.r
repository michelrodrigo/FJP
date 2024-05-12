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
                                                          choices = unique(dados$MUNICÍPIO),
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
                                   choices = unique(dados$MUNICÍPIO),
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
               span("População total: ", textOutput(outputId = 'populacao', inline = TRUE)))
          
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
