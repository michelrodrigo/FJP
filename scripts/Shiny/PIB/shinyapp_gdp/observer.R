values<-reactiveValues(starting=T)
    session$onFlushed(function() {  values$starting <- F})

    # observe session
    
    observe({
      if (input$selected %in% noSectors)
      updateSelectizeInput(session,'sector',selected='all')
    })
    
    observe({

      Sys.sleep(0.1)
      selected <- input$selected
      updateSliderInput(session,'slider1',value=startYear[[selected]],min=startYear[[selected]],max=endYear[[selected]])
    })
    
    observe({

      nonCorr<-input$heatX != input$heatY
      Sys.sleep(0.1)
      if (grepl('growth',input$selected) & nonCorr)
          updateSelectizeInput(session,inputId='heatR',choices=c('absolute'))
      else if (!grepl('growth',input$selected) & nonCorr) {updateSelectizeInput(session,inputId='heatR',choices=heatRelative)}
      else {updateSelectizeInput(session,inputId='heatR',choices=c('time series'))}
    })
    
    observe({

      Sys.sleep(0.1)
      isInside <- input$heatY %in% c(heatYChoices,input$heatX)
      if (input$heatX!='sectors' & isInside)
          { updateSelectizeInput(session,'heatY',choices=unique(c(heatYChoices,input$heatX)),selected=input$heatY) }
      else if (input$heatX != 'sectors' & !isInside) {
        updateSelectizeInput(session,'heatY',choices=unique(c(heatYChoices,input$heatX)))}
      else { updateSelectizeInput(session,'heatY',choices=c('sectors')) }
    })

    observe({

      Sys.sleep(0.1)
      if (input$heatX==input$heatY)
        updateSelectizeInput(session,'heatR',label=ts_cs,choices=c('time series'))#,'cross sectional'))
      else if (!grepl('growth',input$selected)) {
        originalOrElse<-ifelse(input$heatR%in%heatRelative,input$heatR,heatRelative[1])
        updateSelectizeInput(session,'heatR',label=rela_abso,choices=heatRelative,selected=originalOrElse)}
      
    })
    
    observe({ updateSelectizeInput(session,'coordY',label='Y coordinate',setdiff(sectorsAbbreviations,input$coordX),selected='Finance') })
    observe({ updateSelectizeInput(session,'stateB',label='second state',setdiff(states,input$stateA),selected='New York') })
    
    observe({

      Sys.sleep(0.1)
      if (input$heatX==input$heatY) 
      {output$title4<-renderText(paste(input$heatX,'vs',input$heatY, "Correlation"))}  
      else if (!('years' %in% c(input$heatX,input$heatY)) & input$heatR!='time series')
      { output$title4<-renderText(paste0("Now it is year ",input$slider1)) }
      else { output$title4<-renderText(paste(input$heatX,'vs Years 2D HEAT MAP'))}
    })
    