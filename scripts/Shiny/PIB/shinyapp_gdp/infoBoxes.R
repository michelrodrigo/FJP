   # show statistics using infoBox
    output$maxBox <- renderInfoBox({

        if (values$starting) { Xyear<-'X2007'}
        else { Xyear = getYear() }
        DF<-getDataFrame()
        DF<-TreatAsMissing(DF,bound=ifelse(grepl('growth',input$selected),5,1e16))
        outData <- DF[,Xyear]
        
        max_value <- max(outData,na.rm=T)
        max_state <- FindStateAbbreviation(DF$GeoName[outData == max_value])
        infoBox(max_state, ConvertNum(max_value), icon = icon("chevron-up"),color='blue')
    })
    output$minBox <- renderInfoBox({

        if (values$starting) { Xyear='X2007'}
        else { Xyear = getYear() }
        DF<-getDataFrame()
        DF<-TreatAsMissing(DF,bound=ifelse(grepl('growth',input$selected),5,1e16))
        outData <- DF[,Xyear]
        min_value <- min(outData,na.rm=T)
        min_state <- FindStateAbbreviation(DF$GeoName[outData == min_value])
        infoBox(min_state, ConvertNum(min_value), icon = icon("chevron-down"),color='red')
    })
    output$medBox <- renderInfoBox({
      
        if (values$starting) { Xyear='X2007'}
        else { Xyear = getYear() }
        DF<-getDataFrame()
        DF<-TreatAsMissing(DF,bound=ifelse(grepl('growth',input$selected),5,1e16))
        outData <- DF[,Xyear]
        infoBox(paste("MEDIAN", input$selected),
                ConvertNum(median(outData,na.rm=T)),
                icon = icon("calculator"),color='green')
    })
    