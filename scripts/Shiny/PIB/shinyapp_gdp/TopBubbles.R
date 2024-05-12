   output$bubble <- renderBubbles({
      
      if (!(input$selected %in% names(data))) return(NULL)
    
      Xyear <- getYear()
      DF<-getDataFrame()
      DF <-DF[,c('GeoName',Xyear)]
      if (!is.numeric(DF[[Xyear]])) DF[[Xyear]]<-type.convert(DF[[Xyear]])
      DF[is.na(DF)]<-0.0
      DF<-DF[order(DF[[Xyear]],decreasing=T),]
      DF<-head(DF,input$slider2)
      minValue <- min(DF[[Xyear]],na.rm=T)
      DF[is.na(DF)]<-minValue-0.1
      if (minValue<0) DF[[Xyear]] <- DF[[Xyear]] - 1.2*min(DF[[Xyear]])
      colors1<-two.colors(input$slider2,start='#0B2161',end='#F5A9F2',middle='#01A9DB',alpha=1.0)
      output$title3<-renderText(paste("Now it is year ",sub("X",'',Xyear)))
      bubbles(sqrt(DF[[Xyear]]), DF$GeoName, key = DF$GeoName, color=colors1,textColor='#FFFFFF')
    })