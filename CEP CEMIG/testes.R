library(readxl)
library(tidyverse)

dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir)

dados_cemig <- read_excel("Coord_Cep.xlsx")
a <- dados_cemig |> select(c("NOM_LOGRAD", "COD_CEP"))


b <- a |> group_by(COD_CEP, NOM_LOGRAD) |> summarise(n = n())
c <- b |> group_by(COD_CEP) |> summarise(n = n())
