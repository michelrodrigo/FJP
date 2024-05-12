   getYear<-reactive({ 

      if (values$starting) return('X2015')
      year<-as.numeric(input$slider1)
      if (startYear[[input$selected]]>year) {year<-startYear[[input$selected]]}
      if (endYear[[input$selected]]<year) {year<-endYear[[input$selected]]}
      return(paste0('X',year))}
      )
    
    getDataStates<-reactive({

      if (!(input$selected %in% names(data))) return(NULL)
      return(data[[input$selected]])
    })

    getDataRegions<-reactive({

      if (!(input$selected %in% names(GDP_regions))) return(NULL)
      return(GDP_regions[[input$selected]])
      
    })
    
    getSectorRGDPSectorDataStates<-reactive({

      if (!(input$sector %in% names(rGDP_sector_states))) return(NULL)
      return(list(original=rGDP_sector_states[[input$sector]],
                  growth=rGDP_sector_states_growth[[input$sector]]))
    })
    
    getSectorNGDPSectorDataStates<-reactive({

      if (!(input$sector %in% names(nGDP_sector_states))) return(NULL)
      return(list(original=nGDP_sector_states[[input$sector]],
                  growth=nGDP_sector_states_growth[[input$sector]]))
    })
    
    getSectorRGDPSectorDataRegions<-reactive({
      if (!(input$sector %in% names(rGDP_sector_regions))) return(NULL)
      return(list(original=rGDP_sector_regions[[input$sector]],
                  growth=rGDP_sector_regions_growth[[input$sector]]))
      
    })
        
    getSectorNGDPSectorDataRegions<-reactive({
      if (!(input$sector %in% names(nGDP_sector_regions))) return(NULL)
      return(list(original=nGDP_sector_regions[[input$sector]],
                  growth=nGDP_sector_regions_growth[[input$sector]]))
      
    })
    
    getDataFrame<-reactive({
      
      if (input$selected %in% noRegions | input$selected %in% noSectors | input$sector=='all')
        DF<-getDataStates()
      else { if (grepl('nominal',input$selected)) 
        myList<-getSectorNGDPSectorDataStates()
      else if (grepl('real',input$selected))
        myList<-getSectorRGDPSectorDataStates()
      
      if (is.null(myList)) return(NULL)
      if (input$sector!='all' & grepl('growth',input$selected))
        DF<-myList[['growth']]
      else DF<-myList[['original']] }
      DF
    })
    