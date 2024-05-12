source('global.R')


#Define UI for application that draws a histogram
ui <- dashboardPage(skin = "green",
                    
                    # Application title
                    titulo <- dashboardHeader(title = "IMRS Demografia"),
                    
                    # Sidebar with a slider input for number of bins 
                    dashboardSidebar(
                      sidebarMenu(id = "barra_lateral",
                                  menuItem("Municípios", tabName = 'municipios'),
                                  conditionalPanel(condition = "input.barra_lateral == 'municipios'",
                                                   
                                                   selectizeInput(inputId = 'selecao_municipio', label = "Selecione o(s) município(s)", choices = NULL, selected = NULL, multiple = TRUE,
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
                    
                    #useShinyalert(),  # Set up shinyalert
)