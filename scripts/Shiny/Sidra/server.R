
library("shiny")
library("sidrar")


server <- function(input, output, session) {
  
  
  
  
  
  titulo <- eventReactive(
    input$go, {
      page <- readLines(paste0("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", input$tabela), warn = FALSE, encoding = "UTF-8")
      pos <- grep('id="lblNomeTabela"', page)
      mypattern <- 'class="tituloTabelaDesc">([^<]*)</span>'
      datalines = grep(mypattern,page[pos:length(page)],value=TRUE)
      getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
      gg = gregexpr(mypattern,datalines)
      matches = mapply(getexpr,datalines,gg)
      gsub(mypattern,'\\1',matches)
      
      
    })
  
  output$titulo_tabela <- renderText({
    titulo()
  })
  
  
  periodos <- eventReactive(
    input$go, {
      page <- readLines(paste0("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", input$tabela),  warn = FALSE,encoding = "UTF-8")
      pos <- grep('id="lblNomePeriodo"', page)
      mypattern <- 'tituloLinha">([^<]*)\\('
      datalines = grep(mypattern,page[pos],value=TRUE)
      getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
      gg = gregexpr(mypattern,datalines)
      matches = mapply(getexpr,datalines,gg)
      nome_periodo <- gsub(mypattern,'\\1', matches)
      
      mypattern <- '\\(([^<]*)\\):</span>'
      datalines = grep(mypattern,page[pos],value=TRUE)
      getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
      gg = gregexpr(mypattern,datalines)
      matches = mapply(getexpr,datalines,gg)
      numero_periodo <- as.numeric(gsub(mypattern,'\\1', matches))
      
      pos <- grep('id="lblPeriodoDisponibilidade"', page)
      mypattern <- 'Red;">([^<]*)</span>'
      datalines = grep(mypattern,page[pos],value=TRUE)
      gg = gregexpr(mypattern,datalines)
      matches = mapply(getexpr,datalines,gg)
      periodos_nomes <- as.list(strsplit(gsub(mypattern,'\\1', matches), ',')[[1]])
      periodos_nomes <- rev(lapply(periodos_nomes, trimws, 'both'))
      
      updateCheckboxGroupInput (session = session, "periodos_consulta",
                                choiceNames = periodos_nomes,
                                choiceValues = c(periodos_nomes))
      
      
    })
  
  variaveis <- eventReactive(
    input$go, {
      page <- readLines(paste0("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", input$tabela),  warn = FALSE,encoding = "UTF-8")
      pos <- grep('id="lblVariaveis', page)
      mypattern <- 'Variável\\(([^<]*)\\):</span>'
      datalines = grep(mypattern,page[pos],value=TRUE)
      getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
      gg = gregexpr(mypattern,datalines)
      matches = mapply(getexpr,datalines,gg)
      num_var <- as.numeric(gsub(mypattern,'\\1', matches))
      variaveis_nomes <- vector('list', num_var+1)
      variaveis_valores <- vector('list', num_var+1)
      variaveis_valores <- vector('list', num_var+1)
      for(i in c(1:num_var)){
        pos <- grep(paste0('id="lstVariaveis_lblNomeVariavel_', i-1), page)
        mypattern <- '>([^<]*)</span>'
        datalines = grep(mypattern,page[pos],value=TRUE)
        gg = gregexpr(mypattern,datalines)
        matches = mapply(getexpr,datalines,gg)
        variaveis_nomes[i] <- gsub(mypattern,'\\1', matches[2])
        variaveis_valores[i] <- gsub(mypattern,'\\1', matches[1])
      }
      
      
      variaveis_nomes[i+1] <- "Todas"
      variaveis_valores[i+1] <- "all"
      
      
      updateCheckboxGroupInput (session = session, "Variaveis_consulta",
                                choiceNames = variaveis_nomes,
                                choiceValues = variaveis_valores
                                
      )
    })
  
  territorios <- eventReactive(
    input$go, {
      page <- readLines(paste0("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", input$tabela), warn = FALSE, encoding = "UTF-8")
      pos <- grep('NomeNivelterritorial', page)
      territorios_nomes <- vector('list', length(pos))
      mypattern <- 'NomeNivelterritorial_([^<]*)</span><span'
      datalines = grep(mypattern,page[pos],value=TRUE)
      getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
      gg = gregexpr(mypattern,datalines)
      matches = mapply(getexpr,datalines,gg)
      for(i in c(1:length(territorios_nomes))){
        territorios_nomes[[i]] <- strsplit(gsub(mypattern,'\\1', matches[[i]]), split = ">", fixed = TRUE)[[1]][2]
      }
      
      updateSelectInput(session = session, "territorios_consulta",
                        choices = territorios_nomes,
      )
      
      
    }
  )
  
  api <- eventReactive(
    input$api, {
      a <- paste('/t/', input$tabela, collapse = "", sep = "")
      a <- paste(a, '/p/', paste(input$periodos_consulta,  collapse = ","), collapse = "", sep = "")
      a <- paste(a, '/v/', paste(input$Variaveis_consulta,  collapse = ","), collapse = "", sep = "")
    }
  )
  
  output$string_api <- renderText({
    api()
  })
  
  
  observe({
    variaveis()
  })
  
  observe({
    periodos()
  })
  
  observe({
    territorios()
  })
  
  
  
  
}