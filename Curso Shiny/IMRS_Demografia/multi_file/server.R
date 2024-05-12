
source('global.R')

server <- function(input, output, session) {
  
  updateSelectizeInput(session, 'selecao_municipio', choices = dados_pop$MUNICÍPIO, server = TRUE)
  updateSelectizeInput(session, 'selecao_indicador_tabela', choices = opcoes_indicadores, server = TRUE)
  #updateSelectInput(session, 'selecao_indicador_grafico', choices = opcoes_indicadores, selected = NULL)
  updateSelectizeInput(session, 'selecao_ano', choices = unique(dados_pop$ANO), server = TRUE)
  
  
  output$tabela <- renderDataTable({
    
    tab <- dados_pop |> 
      select(c("MUNICÍPIO", "ANO", "IBGE6", input$selecao_indicador_tabela)) |>
      filter(MUNICÍPIO %in% input$selecao_municipio & ANO %in% input$selecao_ano)
    
  })
  
  output$grafico_hi <- renderHighchart({
    
    req(input$selecao_municipio)
    req(input$selecao_indicador_grafico)
    
    dados <- lapply(input$selecao_municipio, function(x){
      dados <- dados_pop |>  
        subset(MUNICÍPIO %in% x & (ANO >= input$selecao_anos[1]) & (ANO <= input$selecao_anos[2])) |>  
        select(c(MUNICÍPIO, ANO, input$selecao_indicador_grafico)) 
      colnames(dados) <- c("MUNICÌPIO", "ANO", "INDICADOR")
      
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
      valores$mun <- sample(dados_pop$MUNICÍPIO, num)
      
      paste(valores$mun, collapse = ", ")
    }
    
  })
  
  observeEvent(input$atualizar_municipios, {
    updateCheckboxGroupInput(session, inputId = 'selecao_municipios', choices = valores$mun )
  })
  
  output$pop_homem_mulher <- renderText({
    dados <- dados_pop |> subset(ANO == 2020 & MUNICÍPIO %in% input$selecao_municipios) |> select(MUNICÍPIO, HOMEMTOT, MULHERTOT)
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
      subset(MUNICÍPIO %in% input$selecao_municipio & (ANO >= input$selecao_anos[1]) & (ANO <= input$selecao_anos[2])) |>  
      select(c(MUNICÍPIO, ANO, input$selecao_indicador_grafico)) 
    colnames(dados) <- c("MUNICÌPIO", "ANO", "INDICADOR")
    dados <- data.frame(dados)
  })
  
  output$grafico_ggplot <- renderPlot({
    
    
    ggplot(selected(), aes(x = ANO, y = INDICADOR, colour = MUNICÌPIO )) +
      geom_point(size = 3) +
      geom_line(size = 1)+
      guides(colour = guide_legend(title=NULL))+
      labs(title = paste("Indicador: ", input$selecao_indicador_grafico), 
           x = "Ano", y = "Valor do indicador")
    
    
  })
  
  output$media_area <- renderText({
    dados <- dados_pop |> subset(ANO == 2020)
    media <- sum(dados$AREA)/ length(unique(dados$MUNICÍPIO))
  })
  
  output$media_pop <- renderText({
    dados <- dados_pop |> subset(ANO == 2020)
    media <- sum(dados$D_POPTA)/ length(unique(dados$MUNICÍPIO))
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