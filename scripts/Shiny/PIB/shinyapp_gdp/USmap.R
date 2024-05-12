   output$map <- renderGvis({

      if (values$starting) return(NULL)
      Sys.sleep(0.3)
 
      DF<-getDataFrame()
      DF1<-DF[,getYear()]
      DF1<-TreatAsMissing(DF1,bound=ifelse(grepl('growth',input$selected),5,1e16))
      maxV<-max(DF1)
      minV<-min(DF1)
      medV<-median(DF1)
      colorStr=paste("{values:[",minV,",",medV,",",maxV,"],")
      gvisGeoChart(DF, "GeoName", getYear(),
                   options=list(region="US", displayMode="regions", 
                                resolution="provinces", width='1200px',height='700px',
                                backgroundColor='#F6E3CE',colorAxis=paste0(colorStr,"colors:['red','#FBEFEF','#0404B4']}")))
    })   
    