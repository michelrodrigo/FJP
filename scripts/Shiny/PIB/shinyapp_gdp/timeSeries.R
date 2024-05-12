   output$linePlot <- renderGvis({

      if (values$starting) return(NULL)
      Sys.sleep(0.3)
      output$warning <- renderText(paste('No data to display for',input$selected,'with the current state/region choices'))
      selected <- input$selected
      if (input$state1=='None' & input$region1 == 'None') return(NULL)
      myStates  = c()
      myRegions = c()
      selected <- input$selected
      if (input$sector=='all') {
          if (input$state1=='None') {myData<-getDataRegions()}
          else {myData<-getDataStates()}
      } else 
      {
        if (input$state1=='None') {

           if (input$region1=='None') return(NULL)
           if (grepl('real',selected)) myList<-getSectorRGDPSectorDataRegions()
           else myList<-getSectorNGDPSectorDataRegions() }
        else {

          if (grepl('real',selected)) myList<-getSectorRGDPSectorDataStates()
          else myList<-getSectorNGDPSectorDataStates()
        }
        growToken <- ifelse(grepl('growth',selected),'growth','original')
        myData <- myList[[growToken]]
      }  

      if (is.null(myData)) return(NULL)
      year_e   <- endYear[[selected]]
      Xyear    <- getYear()
      year_s   <- max(c(strtoi(sub('X','',Xyear)),startYear[[selected]]))
      
      DF<-myData[,c('GeoName',paste0('X',seq(year_s,year_e)))]
  
      if (input$state1 != 'None' & !is.null(input$state2))  {myStates=unique(c(input$state1,input$state2))}
      else if (input$state1 != 'None') {myStates=input$state1}
      else if (input$region1 != 'None' & !is.null(input$region2)) {myRegions=unique(c(input$region1,input$region2))}
      else if (input$region1 != 'None') {myRegions=input$region1}
      else return(NULL)
      if(length(myStates)>0){myColumns=myStates}
      else {myColumns=myRegions}
      
      P<-DF %>% filter(GeoName %in% myColumns)
      myColumns <- P[,'GeoName']
      Y<-data.frame(t(P[,-1]))
      if (length(myStates)>0) names(Y) <- FindStateAbbreviation(myColumns)
      else names(Y)<-FindRegionAbbreviation(myColumns)
      
      Y['year']<-as.integer(seq(year_s,year_e))
      output$warning<-renderText(paste(myColumns,collapge='',input$selected,'Time Series:'))
      yTitle <- ifelse(grepl('growth',selected),paste(selected,'percentage'),selected)
      if (grepl('growth',selected)) myOption <- list(vAxis="{format:'#,###%'}")
      else myOption <- list()
      gvisLineChart(Y,xvar='year',yvar=names(Y[-ncol(Y)]),options=myOption)
    })   
    