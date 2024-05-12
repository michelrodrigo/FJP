library("shiny")
library("shinyjs")


ui <- fluidPage(

    
   useShinyjs(),

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
   
   selectInput(inputId = "uf", 
               label = "UF", 
               choices = c("Escolha")
              ),
      
   
   selectInput(inputId = "territorios_unidades",
               label = "Selecione as unidades territoriais:",
               choices = c("Escolha")
               
   ),
   
   
   
  
)

server <- function(input, output, session) {
  
  
  pagina <- reactiveVal(0)
  pagina2 <- reactiveVal(1)

  
  titulo <- eventReactive(
    input$go, {
      pagina(readLines(paste("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", input$tabela), warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE))
      page <- pagina()
      #page <- readLines(paste("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", input$tabela), warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)
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
      #page <- readLines(paste("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", input$tabela),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)
      page <- pagina()
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
      #page <- readLines(paste0("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", input$tabela), warn = FALSE, encoding = "UTF-8")
      page <- pagina()
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
      #page <- readLines(paste("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", input$tabela),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)
      page <- pagina()
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
      pos <- grep('IdNivelterritorial', page)
      territorios_valores <- vector('list', length(pos))
      mypattern <- 'IdNivelterritorial_([^<]*)</span><span'
      datalines = grep(mypattern,page[pos],value=TRUE)
      gg = gregexpr(mypattern,datalines)
      matches = mapply(getexpr,datalines,gg)
      for(i in c(1:length(territorios_valores))){
        territorios_valores[[i]] <- strsplit(gsub(mypattern,'\\1', matches[[i]]), split = ">", fixed = TRUE)[[1]][2]
      }
      
      choices <- territorios_valores 
      names(choices) <- territorios_nomes
      
      updateSelectInput(session = session, "territorios_consulta",
                                choices = choices
                                )
      
      
    }
  )
  
  territorios_selecao <- eventReactive(
    input$territorios_consulta, {
      pagina2(readLines(paste("https://apisidra.ibge.gov.br/LisUnitTabAPI.aspx?c=", input$tabela, "&n=", input$territorios_consulta, "&i=P"),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE))
      
      page2 <- pagina2()
      num_colunas <- length(grep('<th>', page2))
      pos <- grep('<td>', page2)
      
      mypattern <- '<td>([^<]*)</td><td'
      datalines = grep(mypattern,page2[pos],value=TRUE)
      getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
      gg = gregexpr(mypattern,datalines)
      matches = mapply(getexpr,datalines,gg)
      unidades_nomes <- vector('list', length(matches))
      for(i in c(1:length(unidades_nomes))){
        unidades_nomes[i] <- gsub(mypattern,'\\1', matches[i])
      }
      
      pos <- grep('<td align', page2)
      mypattern <- 'color="Red">([^<]*)</font></td>'
      datalines = grep(mypattern,page2[pos],value=TRUE)
      getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
      gg = gregexpr(mypattern,datalines)
      matches = mapply(getexpr,datalines,gg)
      unidades_valores <- vector('list', length(matches))
      for(i in c(1:length(unidades_valores))){
        unidades_valores[i] <- gsub(mypattern,'\\1', matches[i])
      }
      
      unidades <- unidades_valores
      names(unidades) <- unidades_nomes
      
      
      updateSelectInput(session = session, "territorios_unidades",
                        choices = unidades
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
  
  observe({
    territorios_selecao()
  })
  
  observeEvent(
    input$territorios_consulta, {
      if (input$territorios_consulta ==  6)
      {
        shinyjs::show("uf")
        
      }
      else
      {
        shinyjs::hide("uf")
      }
    }
  )
  
  
  
  
}

shinyApp(ui = ui, server =  server)