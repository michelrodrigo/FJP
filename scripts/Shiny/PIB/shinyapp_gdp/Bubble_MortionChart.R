  output$bubble2<-renderGvis({

      if (values$starting) return(NULL)
      Sys.sleep(0.3)
      
      selected<-input$selected
      isStates<-T
      isReal  <- grepl('real',selected)
      if (!grepl('growth',selected)) {

        output$titleB<-renderText('Support real or nominal GDP growth only')
        return(NULL)}
      else {output$titleB<-renderText(paste0('Motion Chart of ',input$selected))}
      
      decisionToken = ''
      if (isReal  & isStates)  decisionToken <- 'rs'
      if (isReal  & !isStates) decisionToken <- 'ru'
      if (!isReal & isStates)  decisionToken <- 'ns'
      if (!isReal & !isStates) decisionToken <- 'nu'

      x<-c('r','n')
      names(x)<-x
      y<-c('states','regions')
      names(y)<-c('s','u')
      decisionVec <-strsplit(decisionToken,split='')[[1]]
      dataName <- paste0(x[decisionVec[1]],'GDP_sector_',y[decisionVec[2]],'_growth')
      
      motion_data <- get(dataName,inherits=T)
      coordX<-sectors[input$coordX]
      coordY<-sectors[input$coordY]
      X<-motion_data[[coordX]]
      Y<-motion_data[[coordY]]
      
      Aloc<-input$stateA
      Bloc<-input$stateB
      locPair<-c(Aloc,Bloc)

      if(length(unique(locPair))!=2) return(NULL)

      X<-filter(X,GeoName %in% locPair)
      Y<-filter(Y,GeoName %in% locPair)
      X1<-melt(X,id.var='GeoName')
      Y1<-melt(Y,id.var='GeoName')
      names(X1)<-c('GeoName','Year',input$coordX)
      names(Y1)<-c('GeoName','Year',input$coordY)
      Z<-inner_join(X1,Y1,by=c('GeoName','Year'))
      Z$Year<-type.convert(sub("X",'',Z$Year))
      Z$Color<-factor(Z$GeoName)
      Z$GeoName<-factor(Z$GeoName)
      
      return(gvisMotionChart(Z,idvar='GeoName',timevar='Year', colorvar='Color',
                             xvar=input$coordX,yvar=input$coordY,options=list(width='760px',height='300px')))
      
    })
    