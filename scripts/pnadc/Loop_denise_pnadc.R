cat("\014")


rm(list = ls())
gc()
setwd("C:/ArquivosR/PNADC/PNADCTRIMESTRAL/SCRIPTS")


pacotes <- c(
  "PNADcIBGE",
  "srvyr",
  "survey",
  "dplyr",
  "data.table",
  "stringr",
  "tidyr",
  "xlsx",
  "openxlsx"
)


for(i in pacotes){
  if (!require(i, character.only = TRUE)) {
    install.packages(i)
  } 
  
  library(i, character.only = TRUE)
}
memory.limit(size=9999999999)
source("PNADc Funcoes.R")

#----------------------------------------------------------------------------------------#

#======================================================================================================================#
#                                     ARMAZENAR LISTA DE TABELAS DE DADOS DA PNADC                                     #
#======================================================================================================================#
#-------------------------------- DEFINICAO DE VARIAVEIS --------------------------------#
tab_POPTTBR <- tibble()
tab_POPTTMG <- tibble()
tab_PIABR <- tibble()
tab_PIAMG <- tibble()
tab_condicaoBR <- tibble()
tab_condicaoMG <- tibble()
tab_condicaoUF <- tibble()
tab_condicaocorBR <- tibble()
tab_condicaocorMG <- tibble()
tab_condicao_escol_BR <- tibble()
tab_condicao_escol_MG <- tibble()
tab_desalentoBR <- tibble()
tab_desalentoMG <- tibble()
tab_subocupadoBR <- tibble()
tab_subocupadoMG <- tibble()
tab_posicaoBR <- tibble()
tab_posicaoMG <- tibble()
tab_condicaoidBR <- tibble()
tab_condicaoidMG <- tibble()
tab_condicao_grup_BR <- tibble()
tab_condicao_grup_MG <- tibble()
tab_potencialBR <- tibble()
tab_potencialMG <- tibble()
tab_AmpliadaBR <- tibble()
tab_AmpliadaMG <- tibble()

vetor_anos <- c(2012:2021)
vetor_trimestres <- c(1:4)
ultimoano<-2021
ultimotrimestre<-2
#----------------------------------------------------------------------------------------#

#----------------------------------- ITERACAO (LOOP) ------------------------------------#
# Para cada ano do vetor de anos
for(ano in vetor_anos){
 # Para cada trimestre do vetor de trimestres
  for(trimestre in vetor_trimestres){
    if(ano >= ultimoano & trimestre > ultimotrimestre)
      break
# Caso o ano seja anterior a 2015, utilizar VD4004. Caso contrário, utilizar VD4004A
    indice_PNADc <- paste0(ano, '_T', trimestre)  # Indice textual para armazenar os dados em listas
    dadosPNADc <- get_pnadc(year=ano, quarter=trimestre, design = FALSE)
    dadosPNADc$one <- 1
    
   
    dadosPNADc$idade <- agrupar_idades(dadosPNADc$V2009)
    
 
    
    dadosPNADc <- pnadc_design(dadosPNADc)
    
    POPTTBR <- estimar_populacao(
      x = dadosPNADc,
      formula = ~interaction(Ano, Trimestre, V2007, one),
      regiao = "Brasil"
      
    )
    
    POPTTMG <- estimar_populacao(
      x = subset(dadosPNADc, UF == "Minas Gerais"),
      formula = ~interaction(Ano, Trimestre, V2007, one),
      regiao = "Minas Gerais"
    )
  
    PIABR<- estimar_pia(
      x = dadosPNADc,
      formula = ~interaction(Ano, Trimestre, V2007, VD4001),
      regiao = "Brasil"
    )
    
    PIAMG <- estimar_pia(
      x = subset(dadosPNADc, UF == "Minas Gerais"),
      formula = ~interaction(Ano, Trimestre, V2007,VD4001),
      regiao = "Minas Gerais"
      
    )
    
     condicaoBR <- estimar_condicao(
      x = dadosPNADc,
      formula = ~interaction(Ano, Trimestre, V2007,VD4002),
      regiao = "Brasil"
      
    )
    
    condicaoMG <-estimar_condicao(
      x = subset(dadosPNADc, UF == "Minas Gerais"),
      formula = ~interaction(Ano, Trimestre, V2007,VD4002),
      regiao = "Minas Gerais"
    )
    
  
    
    condicaoUF <- estimar_condicaoUF(
      x = dadosPNADc,
      formula = ~interaction(Ano, Trimestre, UF, V2007,VD4002)
      
    )

    
    condicaocorBR <- estimar_condicao_cor(
      x = dadosPNADc,
      formula = ~interaction(Ano, Trimestre, V2010,VD4002),
      regiao = "Brasil"
    )
    
    condicaocorMG <- estimar_condicao_cor(
      x = subset(dadosPNADc, UF == "Minas Gerais"),
      formula = ~interaction(Ano, Trimestre, V2010,VD4002),
      regiao = "MG"
    )
    
    condicao_escol_BR <- estimar_condicao_escol(dadosPNADc, ~interaction(Ano, Trimestre, VD3004,VD4002),
                                                "Brasil")
    
    condicao_escol_MG <- estimar_condicao_escol(subset(dadosPNADc, UF == "Minas Gerais"), 
                                                ~interaction(Ano, Trimestre, VD3004,VD4002),
                                                "MG")

    desalentoBR <- estimar_desalento(
      x = dadosPNADc,
      formula = ~interaction(Ano, Trimestre, V2007, VD4005),
      regiao = "Brasil"
    )
    
    desalentoMG <- estimar_desalento(
      x = subset(dadosPNADc, UF == "Minas Gerais"),
      formula = ~interaction(Ano, Trimestre, V2007, VD4005),
      regiao = "Minas Gerais"
    )
    
    
   if(ano <= 2014 | ano==2015 & trimestre<4){
     subocupadoBR <- estimar_subocupado(
       x = dadosPNADc,
       formula = ~interaction(Ano, Trimestre, V2007, VD4004),
       regiao = "Brasil"
       
     )
     
     subocupadoMG <- estimar_subocupado(
       x = subset(dadosPNADc, UF == "Minas Gerais"),
       formula = ~interaction(Ano, Trimestre, V2007, VD4004),
       regiao = "Minas Gerais"
       
     )
   } else{
     subocupadoBR <- estimar_subocupado(
       x = dadosPNADc,
       formula = ~interaction(Ano, Trimestre, V2007, VD4004A),
       regiao = "Brasil"
       
     )
     
     subocupadoMG <- estimar_subocupado(
       x = subset(dadosPNADc, UF == "Minas Gerais"),
       formula = ~interaction(Ano, Trimestre, V2007, VD4004A),
       regiao = "Minas Gerais"
       
     )
   }
     
   posicaoBR <- Estimar_Posicao(dadosPNADc, ~interaction(Ano, Trimestre, VD4009, V2007),
                                 "Brasil")
    
    posicaoMG <- Estimar_Posicao(subset(dadosPNADc, UF == "Minas Gerais"), ~interaction(Ano, Trimestre, VD4009, V2007),
                                 "MG")
  
    
    condicaoidBR <- estimar_condicao_id(
      x = dadosPNADc,
      formula = ~interaction(Ano, Trimestre, idade,VD4002),
      regiao = "Brasil"
      
    )
    
    condicaoidMG <- estimar_condicao_id(
      x = subset(dadosPNADc, UF == "Minas Gerais"),
      formula = ~interaction(Ano, Trimestre, idade,VD4002),
      regiao = "MG"
      
    )
    
    
  
    condicao_grup_BR <- estimar_condicao_grup(dadosPNADc, ~interaction(Ano, Trimestre, VD4010,VD4002),
                                              "Brasil") 
    condicao_grup_BR$"Pessoas desocupadas" <- NULL #deletar uma coluna
    
    condicao_grup_MG <- estimar_condicao_grup(subset(dadosPNADc, UF == "Minas Gerais"), 
                                              ~interaction(Ano, Trimestre, VD4010,VD4002),
                                              "MG")
    condicao_grup_MG$"Pessoas desocupadas" <- NULL #deletar uma coluna
    
    
    potencialBR <- estimar_potencial(
      x = dadosPNADc,
      formula = ~interaction(Ano, Trimestre, V2007,VD4003),
      regiao = "Brasil"
      
    )
    
    potencialMG <-estimar_potencial(
      x = subset(dadosPNADc, UF == "Minas Gerais"),
      formula = ~interaction(Ano, Trimestre, V2007,VD4003),
      regiao = "Minas Gerais"
    )
    
    

    
    AmpliadaBR<- full_join (condicaoBR, potencialBR)
    AmpliadaBR$"Força de trabalho ampliada"<-rowSums(AmpliadaBR[, 5:7])
    
 
    
    AmpliadaMG<- full_join (condicaoMG, potencialMG)
    AmpliadaMG$"Força de trabalho ampliada"<-rowSums(AmpliadaMG[, 5:7])
    
    tab_POPTTBR <- rbind (tab_POPTTBR, POPTTBR) 
    tab_POPTTMG <- rbind (tab_POPTTMG, POPTTMG) 
    tab_PIABR <- rbind (tab_PIABR, PIABR) 
    tab_PIAMG <- rbind (tab_PIAMG, PIAMG) 
    tab_condicaoBR <- rbind (tab_condicaoBR, condicaoBR)
    tab_condicaoMG <- rbind (tab_condicaoMG, condicaoMG)
    tab_condicaoUF <- rbind (tab_condicaoUF, condicaoUF)
    tab_condicaocorBR <- rbind (tab_condicaocorBR, condicaocorBR)
    tab_condicaocorMG <- rbind (tab_condicaocorMG, condicaocorMG)
    tab_condicao_escol_BR <- rbind (tab_condicao_escol_BR, condicao_escol_BR)
    tab_condicao_escol_MG <- rbind (tab_condicao_escol_MG, condicao_escol_MG)
    tab_desalentoBR <- rbind (tab_desalentoBR, desalentoBR)
    tab_desalentoMG <- rbind (tab_desalentoMG, desalentoMG)
    tab_subocupadoBR <- rbind (tab_subocupadoBR, subocupadoBR)
    tab_subocupadoMG <- rbind (tab_subocupadoMG, subocupadoMG)
    tab_posicaoBR <- rbind (tab_posicaoBR, posicaoBR)
    tab_posicaoMG <- rbind (tab_posicaoMG, posicaoMG)
    tab_condicaoidBR <- rbind (tab_condicaoidBR, condicaoidBR)
    tab_condicaoidMG <- rbind (tab_condicaoidMG, condicaoidMG)
    tab_condicao_grup_BR <- rbind (tab_condicao_grup_BR, condicao_grup_BR)
    tab_condicao_grup_MG <- rbind (tab_condicao_grup_MG, condicao_grup_MG)
    tab_potencialBR <- rbind (tab_potencialBR, potencialBR)
    tab_potencialMG <- rbind (tab_potencialMG, potencialMG)
    tab_AmpliadaBR <- rbind (tab_AmpliadaBR, AmpliadaBR)
    tab_AmpliadaMG <- rbind (tab_AmpliadaMG, AmpliadaMG)
    
  }
  if(ano >= ultimoano & trimestre > ultimotrimestre)
    break
}

lista_mercadotrabalho<-list(tab_POPTTBR, tab_POPTTMG, tab_PIABR, tab_PIAMG, tab_condicaoBR,
                            tab_condicaoMG, tab_condicaoUF,tab_condicaocorBR, tab_condicaocorMG,
                            tab_condicaocorBR, tab_condicaocorMG,tab_condicao_escol_BR, tab_condicao_escol_MG,
                            tab_desalentoBR, tab_desalentoMG,tab_subocupadoBR, tab_subocupadoMG,tab_posicaoBR,
                            tab_posicaoMG,tab_condicaoidBR, tab_condicaoidMG, tab_condicao_grup_BR, tab_condicao_grup_MG,
                            tab_potencialBR, tab_potencialMG, tab_AmpliadaBR, tab_AmpliadaMG)

install.packages("writexl")
library(writexl)
write_xlsx(lista_mercadotrabalho, "Mercado_Trabalho.xlsx")

#----------------------------------------------------------------------------------------#