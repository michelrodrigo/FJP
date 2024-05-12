##### SCRIPT PNADCT #####


cat("\014")
rm(list = ls())
gc()

#setwd("C:/ArquivosR/PNADCT")
dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir)


pacotes <- c("PNADcIBGE", "srvyr", "survey", "dplyr", "data.table", "stringr",
             "tidyr", "xlsx", "openxlsx", "rio", "tidyverse")

for(i in pacotes){if (!require(i, character.only = TRUE)) {install.packages(i)} 
library(i, character.only = TRUE)}



##### Importa os microdados junto com o input #####

dadospnadc <- get_pnadc (year = 2020, quarter = 1, vars=c("UF","V2007","VD4001","VD4002", "VD4003"))


##### PIA #####

pia_br <- as.data.frame(svytotal(~interaction (V2007,VD4001), dadospnadc, na.rm = T))
pia_mg <- as.data.frame(svytotal(~interaction (V2007,VD4001), subset(dadospnadc, UF == "Minas Gerais"), na.rm = T))

pia_br <- mutate(pia_br, variavel = row.names(pia_br))
pia_br <- pivot_wider(pia_br[, -2], names_from = variavel, values_from = total)
pia_br <- pia_br %>% mutate(ano = 2020  ) %>% mutate(trimestre = 1)
    

xlsx1 <- createWorkbook()
addWorksheet(xlsx1, "pia_br")
addWorksheet(xlsx1, "pia_mg")
writeData(xlsx1, "pia_br", pia_br)
writeData(xlsx1, "pia_mg", pia_mg)
saveWorkbook(xlsx1, file = "C:\\ArquivosR\\PNADCT\\pia.xlsx", overwrite = TRUE)


