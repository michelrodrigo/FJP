output$heat<-renderPlot({

      if (values$starting) return(NULL)
      Sys.sleep(0.6)
      heatX<-input$heatX
      if (heatX=='None') {
        output$title4<-renderText("Heat Map X variable cannot be None!")
        return(NULL)
      } else if (heatX=='sectors' & input$heatY!='sectors') {return(NULL)}
        
      heatY<-input$heatY
      correlational<-(heatX==heatY)
      selected<-input$selected
      isReal<-grepl('real',selected)
      isGrowth<-grepl('growth',selected)
      isTimeSeries<-grepl('time',input$heatR)
      
      if (!(selected %in% support_byYear)) {
        output$title4<-renderText("Only support (real or nominal) GDP (.|growth)")
        return(NULL)}
      if (correlational & !isGrowth) {
        output$title4<-renderText("Only support (real or nominal) GDP growth")
        return(NULL)
      }
      # choose the right data to use
      T1<-ifelse(isReal,'rGDP','nGDP')
      T2<-ifelse(grepl('states',heatX),'_states','_regions')
      T3<-ifelse(isGrowth,'_growth','')
      T4<-'_byYear'
      
      if (heatY=='sectors' & !correlational) {
          varName <- paste0(T1,T2,T3,T4)
          DF<-(get(varName)[[getYear()]])
      }
      else if (input$sector=='all' & !correlational) {
          if (heatX=='states') DF <- getDataStates()
          else { DF <- getDataRegions() }
        
      } else if (input$sector!='all' & !correlational) {
          if (heatX=='states' & grepl('real',selected)) {myList<-getSectorRGDPSectorDataStates()}
          else if (heatX=='states' & !isReal) {myList<-getSectorNGDPSectorDataStates()}
          else if (heatX=='regions' & isReal) {myList<-getSectorRGDPSectorDataRegions()}
          else {myList<-getSectorNGDPSectorDataRegions()}
          if (!isGrowth) {DF<-myList[['original']]}
          else { DF<-myList[['growth']]}
      }
      
      if (correlational) {
        if (isTimeSeries) {
          if (heatX=='states'){
            if (input$sector=='all') { DF<-getDataStates() }
            else {if(isReal) {DF<-getSectorRGDPSectorDataStates()[['growth']]}
                  else {DF<-getSectorNGDPSectorDataStates()[['growth']]}
                 }
          } else if (heatX == 'US regions') {
            if (input$sector=='all') { DF<-getDataRegions()
            } else  { 
                    if (isReal) { DF<-getSectorRGDPSectorDataRegions()[['growth']] }
                    else { DF<-getSectorNGDPSectorDataRegions()[['growth']] }
                    DF<-filter(DF,!grepl('United States',GeoName)) }
            } else if (heatX=='sectors') {
               if (isReal) { X<-rGDP_sector_regions_growth} 
               else { X<- nGDP_sector_regions_growth }

               for (key in names(X)) { X[[key]]<-filter(X[[key]],GeoName=='United States')}
               DF<-StackDFs(X,'Sectors')
            } else {return(NULL)}
        } else {
           # stub, not implemented yet for cross sessional correlations
          if (heatX=='states'){
          } else if (heatX=='regions') {
          } else if (heatX=='sectors') {
          }          
        }
         if (!exists('DF')) { 
           return(NULL)}
           myScale = 1.0
         if (heatX=='states') { 
           rownames(DF)<-FindStateAbbreviation(DF[,1])
           myScale = 0.7
         }
         else if (heatX =='US regions') {rownames(DF)<-FindRegionAbbreviation((DF[,1]))}
         else if (heatX == 'sectors')  {rownames(DF)<-sectorsAbbreviations}
         DF<-DF[,-1]
         DF<-t(DF)
         corMatrix<-cov2cor(var(DF,na.rm=T))
         return(corrplot(corMatrix,method='circle',tl.cex=myScale,type='lower'))
      }
      
      DF<-TreatAsMissing(DF)
      
      if (input$heatR=='relative') {

           if (input$heatY=='sectors') DF<-NormalizeDFAlongRows(DF)
           else DF<-NormalizeDFAlongColumns(DF)
        }

      DF<-melt(DF,id.var='GeoName')

      if (heatY=='sectors') DF<-transmute(DF,GeoName=factor(GeoName),Sector=factor(variable),value)
      else DF<-transmute(DF,GeoName=factor(GeoName),years=factor(variable),value)

      if (heatX=='US regions') DF<-filter(DF,GeoName!='United States')
      
      if (heatY=='sectors') g <- ggplot(DF, aes(x=GeoName, y=SectorAbbre(Sector),fill=value))
      else g <- ggplot(DF,aes(x=GeoName,y=sub('X','',years),fill=value))
      g<- g+ geom_tile() + scale_fill_gradientn(colors=c('black','dark red','red','orange','yellow','white')) 
      g<- g + xlab(switch(paste0(heatX,'W'),statesW='States',regionsW='US regions',sectorsW='Sectors'))
      g<- g + ylab(switch(paste0(heatY,'W'),statesW='States',yearsW='Years',regionsW='US regions',sectorsW='Sectors'))
      g<- g+ theme(axis.text.x=element_text(angle = 90, vjust = 0.5))
      return(g)                                                                                                                                                                      
      
    })
