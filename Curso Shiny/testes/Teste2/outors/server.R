server <- function(input, output) {
  
  output$tabela <- renderDataTable({
    req(input$indicadores, input$municipios, input$ano_tabela)
    dados |> select(c(MUNICÍPIO, ANO, input$indicadores)) |>
      subset(MUNICÍPIO %in% input$municipios & ANO %in% input$ano_tabela)
  })
  
  output$grafico <- renderHighchart({
    
    req(input$municipios_grafico)
    req(input$indicadores_grafico)
    
    dados_final <- lapply(input$municipios_grafico, function(x){
      dados_selecionados <- dados |>  
        subset(MUNICÍPIO %in% x & (ANO >= input$ano_grafico[1]) & (ANO <= input$ano_grafico[2])) |>  
        select(c(MUNICÍPIO, ANO, input$indicadores_grafico)) 
      colnames(dados_selecionados) <- c("MUNICÍPIO", "ANO", "INDICADOR")
      
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
    mun <- isolate(sample(unique(dados$'MUNICÍPIO'), input$num_municipios))
    meus_dados$mun <- mun
    paste(mun, collapse = ", ")
    
    
  })
  
  observeEvent(input$atualizar_municipios, {
    updateCheckboxGroupInput(inputId = 'selecao_municipios', choices = meus_dados$mun)
  })
  
  output$populacao <- renderText({
    dados_selecionados <- dados |> subset(dados$'MUNICÍPIO' %in% input$selecao_municipios & ANO == 2020)
    sum(dados_selecionados$D_POPTA)
  })
}