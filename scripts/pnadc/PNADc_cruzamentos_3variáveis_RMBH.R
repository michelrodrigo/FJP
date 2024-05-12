#Limpando a memória do R
rm(list = ls())
#Limpando o console
cat("\014")
#Configurando a pasta para importar e exportar arquivos do computador
setwd("H://FJP//scripts//pnadc")
#Carregando as bibliotecas
library(plyr)
library(readr)
library(dplyr)
library(questionr)
library(PNADcIBGE)
library(survey)
library(tidyverse)
library(srvyr)
library(csv)
library(data.table)
library(openxlsx)
library(PnadcTidy)
library(rio)
library(dplyr)
library(tidyverse)
library(srvyr)
library(csv)
library(data.table)
library(openxlsx)
library(rio)

#Importando a PNADC com a seleção de variáveis
pnadc20201 <- PnadcTidy(inputSAS="input_PNADC_trimestral.txt", 
                        arquivoPnad="PNADC_012020.txt", 
                        variaveis=c( "UF", "V1023", "Capital", "VD4002", "V2007", "V2009", "VD3004", "VD3005", "V2010", "V1027", "V1028" ))

#Filtrando RMBH
pnadc20201 <- filter(pnadc20201, pnadc20201$UF == 31)
pnadc20201 <- filter(pnadc20201, pnadc20201$V1023 == 1 | pnadc20201$V1023 == 2)


#criando colunas de faixa etária a partir de condições aplicadas a coluna V2009
pnadc20201$i14a17anos <- pnadc20201$V2009 >= 14 & pnadc20201$V2009 <18
pnadc20201$i18a24anos <- pnadc20201$V2009 >= 18 & pnadc20201$V2009 <25
pnadc20201$i25a39anos <- pnadc20201$V2009 >= 25 & pnadc20201$V2009 <40
pnadc20201$i40a59anos <- pnadc20201$V2009 >= 40 & pnadc20201$V2009 <60
pnadc20201$i60anosoumais <- pnadc20201$V2009 >= 60
#Trocando TRUE por 1 e FALSE por 0
pnadc20201$i14a17anos[pnadc20201$i14a17anos == "TRUE"] <- 1
pnadc20201$i14a17anos[pnadc20201$i14a17anos == "FALSE"] <- 0
pnadc20201$i18a24anos[pnadc20201$i18a24anos == "TRUE"] <- 1
pnadc20201$i18a24anos[pnadc20201$i18a24anos == "FALSE"] <- 0
pnadc20201$i25a39anos[pnadc20201$i25a39anos == "TRUE"] <- 1
pnadc20201$i25a39anos[pnadc20201$i25a39anos == "FALSE"] <- 0
pnadc20201$i40a59anos[pnadc20201$i40a59anos == "TRUE"] <- 1
pnadc20201$i40a59anos[pnadc20201$i40a59anos == "FALSE"] <- 0
pnadc20201$i60anosoumais[pnadc20201$i60anosoumais == "TRUE"] <- 1
pnadc20201$i60anosoumais[pnadc20201$i60anosoumais == "FALSE"] <- 0

#Colunas de Nível de instrução - nível 1 2 = Sem instrução e ensino fundamental incompleto
# nível 3 e 4 = ensino fundamental completo e ensimo médio incompleto
# nível 5 e 6 = ensino médio completo e ensino superior incompleto
# nível 7 = ensino superior completo
#a partir de condições aplicadas a VD3004
pnadc20201$nivel1e2 <- pnadc20201$VD3004 == 1 | pnadc20201$VD3004 == 2
pnadc20201$nivel3e4 <- pnadc20201$VD3004 == 3 | pnadc20201$VD3004 == 4
pnadc20201$nivel5e6 <- pnadc20201$VD3004 == 5 | pnadc20201$VD3004 == 6
pnadc20201$nivel7 <- pnadc20201$VD3004 == 7
#Trocando TRUE por 1 e FALSE por 0
pnadc20201$nivel1e2[pnadc20201$nivel1e2 == "TRUE"] <- 1
pnadc20201$nivel1e2[pnadc20201$nivel1e2 == "FALSE"] <- 0
pnadc20201$nivel3e4[pnadc20201$nivel3e4 == "TRUE"] <- 1
pnadc20201$nivel3e4[pnadc20201$nivel3e4 == "FALSE"] <- 0
pnadc20201$nivel5e6[pnadc20201$nivel5e6 == "TRUE"] <- 1
pnadc20201$nivel5e6[pnadc20201$nivel5e6 == "FALSE"] <- 0
pnadc20201$nivel7[pnadc20201$nivel7 == "TRUE"] <- 1
pnadc20201$nivel7[pnadc20201$nivel7 == "FALSE"] <- 0

#Declarando as variáveis categóricas 

pnadc20201$VD4002 <- factor(pnadc20201$VD4002, label=c("Pessoas ocupadas", "Pessoas desocupadas"), levels=1:2)

pnadc20201$V2007 <- factor(pnadc20201$V2007, label=c("Homem", "Mulher"), lev=1:2, ord=T)


#duplicar antes de transformar
pnadc20201$VD30042 <- factor(pnadc20201$VD3004, label=c("Sem instrução e menos de 1 ano de estudo", "Fundamental incompleto ou equivalente", "Fundamental completo ou equivalente",
                                                        "Médio incompleto ou equivalente", "Médio completo ou equivalente", "Superior incompleto ou equivalente",
                                                        "Superior completo "), lev=c(1:7)) 



pnadc20201$V2010 <- factor(pnadc20201$V2010, label=c("Branca", "Preta", "Amarela", "Parda","Indígena", "Ignorado"), lev = c(1,2,3,4,5,9))



###PACOTE SURVEY - Criando um objeto (pnadc202012) declarando a amostra e o peso
###Colocar um nome diferente (ex: adicionar o número 2 ao final), para conseguir visualizar a base (primeiro objeto)
pnadc202012 <-     
  svydesign(            
    ids = ~ UPA ,        
    strata = ~ Estrato , 
    weights = ~ V1028 ,  
    data = pnadc20201 ,  
    nest = TRUE)


#Taxa de desocupação por cor ou raça 
Desocupacao_cor<- data.frame(svytable(~V2010+VD4002, pnadc202012))
Desocupacao_cor<- pivot_wider(Desocupacao_cor, names_from = "VD4002", values_from = "Freq")
Desocupacao_cor$PEA = Desocupacao_cor$`Pessoas ocupadas`+  Desocupacao_cor$`Pessoas desocupadas`
Desocupacao_cor$'Taxa de desocupação' = ((Desocupacao_cor$`Pessoas desocupadas`/ Desocupacao_cor$PEA)*100)
Desocupacao_cor<- rename(Desocupacao_cor, "Cor ou raça" = "V2010")
view(Desocupacao_cor)

#Taxa de desocupação x cor ou raça x sexo
Desocupacao_cor_sexo<- data.frame(svytable(~V2007+VD4002+V2010, pnadc202012))
Desocupacao_cor_sexo<- pivot_wider(Desocupacao_cor_sexo, names_from = "VD4002", values_from = "Freq")
Desocupacao_cor_sexo$PEA = Desocupacao_cor_sexo$`Pessoas ocupadas`+  Desocupacao_cor_sexo$`Pessoas desocupadas`
Desocupacao_cor_sexo$'Taxa de desocupação' = ((Desocupacao_cor_sexo$`Pessoas desocupadas`/ Desocupacao_cor_sexo$PEA)*100)
Desocupacao_cor_sexo<- rename(Desocupacao_cor_sexo, "Cor ou raça" = "V2010", "Sexo" = "V2007")
view(Desocupacao_cor_sexo)

#Taxa de desocupação x idade 
tabela7<-data.frame(svytable(~VD4002+i14a17anos, pnadc202012))
tabela7<-pivot_wider(tabela7, names_from = "VD4002", values_from = "Freq")
tabela7$PEA = tabela7$`Pessoas ocupadas`+  tabela7$`Pessoas desocupadas`
tabela7$'Taxa de desocupação' = ((tabela7$`Pessoas desocupadas`/ tabela7$PEA)*100)

tabela6<-data.frame(svytable(~VD4002+i18a24anos, pnadc202012))
tabela6<-pivot_wider(tabela6, names_from = "VD4002", values_from = "Freq")
tabela6$PEA = tabela6$`Pessoas ocupadas`+  tabela6$`Pessoas desocupadas`
tabela6$'Taxa de desocupação' = ((tabela6$`Pessoas desocupadas`/ tabela6$PEA)*100)

tabela5<-data.frame(svytable(~VD4002+i25a39anos, pnadc202012))
tabela5<-pivot_wider(tabela5, names_from = "VD4002", values_from = "Freq")
tabela5$PEA = tabela5$`Pessoas ocupadas`+  tabela5$`Pessoas desocupadas`
tabela5$'Taxa de desocupação' = ((tabela5$`Pessoas desocupadas`/ tabela5$PEA)*100)


#Taxa de desocupação x idade x sexo
tabela8<- data.frame(svytable(~VD4002+i14a17anos+V2007, pnadc202012))
tabela8<- pivot_wider(tabela8, names_from = "VD4002", values_from = "Freq")
tabela8$PEA = tabela8$`Pessoas ocupadas`+  tabela8$`Pessoas desocupadas`
tabela8$'Taxa de desocupação' = ((tabela8$`Pessoas desocupadas`/ tabela8$PEA)*100)
tabela8<- tabela8[-1, ]
tabela8<- tabela8[-2, ]


tabela9<- data.frame(svytable(~VD4002+i18a24anos+V2007, pnadc202012))
tabela9<- pivot_wider(tabela9, names_from = "VD4002", values_from = "Freq")
tabela9$PEA = tabela9$`Pessoas ocupadas`+  tabela9$`Pessoas desocupadas`
tabela9$'Taxa de desocupação' = ((tabela9$`Pessoas desocupadas`/ tabela9$PEA)*100)
tabela9<- tabela9[-1, ]
tabela9<- tabela9[-2, ]


tabela10<- data.frame(svytable(~VD4002+i25a39anos+V2007, pnadc202012))
tabela10<- pivot_wider(tabela10, names_from = "VD4002", values_from = "Freq")
tabela10$PEA = tabela10$`Pessoas ocupadas`+  tabela10$`Pessoas desocupadas`
tabela10$'Taxa de desocupação' = ((tabela10$`Pessoas desocupadas`/ tabela10$PEA)*100)
tabela10<- tabela10[-1, ]
tabela10<- tabela10[-2, ]


tabela11<- data.frame(svytable(~VD4002+i40a59anos+V2007, pnadc202012))
tabela11<- pivot_wider(tabela11, names_from = "VD4002", values_from = "Freq")
tabela11$PEA = tabela11$`Pessoas ocupadas`+  tabela11$`Pessoas desocupadas`
tabela11$'Taxa de desocupação' = ((tabela11$`Pessoas desocupadas`/ tabela11$PEA)*100)
tabela11<- tabela11[-1, ]
tabela11<- tabela11[-2, ]


tabela12<- data.frame(svytable(~VD4002+i60anosoumais+V2007, pnadc202012))
tabela12<- pivot_wider(tabela12, names_from = "VD4002", values_from = "Freq")
tabela12$PEA = tabela12$`Pessoas ocupadas`+  tabela12$`Pessoas desocupadas`
tabela12$'Taxa de desocupação' = ((tabela12$`Pessoas desocupadas`/ tabela12$PEA)*100)
tabela12<- tabela12[-1, ]
tabela12<- tabela12[-2, ]


#Agrupando idades modo 1
tabela8$i14a17anos <- factor(tabela8$i14a17anos, label=c("14 a 17 anos"), levels=1)
tabela9$i18a24anos <- factor(tabela9$i18a24anos, label=c("18 a 24 anos"), levels=1)
tabela10$i25a39anos <- factor(tabela10$i25a39anos, label=c("25 a 39 anos"), levels=1)
tabela11$i40a59anos <- factor(tabela11$i40a59anos, label=c("40 a 59 anos"), levels=1)
tabela12$i60anosoumais <- factor(tabela12$i60anosoumais, label=c("60 anos ou mais"), levels=1)

colnames(tabela8)[1]<-'Grupo de Idades'
colnames(tabela9)[1]<-'Grupo de Idades'
colnames(tabela10)[1]<-'Grupo de Idades'
colnames(tabela11)[1]<-'Grupo de Idades'
colnames(tabela12)[1]<-'Grupo de Idades'

Desocupacao_idade_sexo<- rbind(tabela8, tabela9, tabela10, tabela11, tabela12)
Desocupacao_idade_sexo<- rename(Desocupacao_idade_sexo, "Sexo" = "V2007")
view(Desocupacao_idade_sexo)


#Taxa de desocupação x nível de instrução x sexo - modo 1 - com 7 níveis 
Desocupacao_instrucao_sexo1<- data.frame(svytable(~VD4002+VD30042+V2007, pnadc202012))
Desocupacao_instrucao_sexo1<- pivot_wider(Desocupacao_instrucao_sexo1, names_from = "VD4002", values_from = "Freq")
Desocupacao_instrucao_sexo1$PEA = Desocupacao_instrucao_sexo1$`Pessoas ocupadas`+  Desocupacao_instrucao_sexo1$`Pessoas desocupadas`
Desocupacao_instrucao_sexo1$'Taxa de desocupação' = ((Desocupacao_instrucao_sexo1$`Pessoas desocupadas`/ Desocupacao_instrucao_sexo1$PEA)*100)
Desocupacao_instrucao_sexo1<- rename(Desocupacao_instrucao_sexo1, "Nível de instrução" = "VD30042", "Sexo" = "V2007")
view(Desocupacao_instrucao_sexo1)

#Resumo Taxa de desocupação x nível de instrução x sexo - modo 1 - com 7 níveis 
Desocupacao_instrucao_sexo_resumo<- subset(Desocupacao_instrucao_sexo1, select = c("Nível de instrução", "Sexo", "Taxa de desocupação"))
Desocupacao_instrucao_sexo_resumo<- pivot_wider(Desocupacao_instrucao_sexo_resumo, names_from = "Nível de instrução", values_from = "Taxa de desocupação")
view(Desocupacao_instrucao_sexo_resumo)


#Taxa de desocupação por nível de instrução (OK com Excel)
tabela2<- data.frame(svytable(~VD4002+VD30042, pnadc202012))

#Taxa de desocupação x nível de instrução x sexo - modo 2 - com 4 níveis 
tabelanivel1e2<- data.frame(svytable(~VD4002+nivel1e2+V2007, pnadc202012))
tabelanivel1e2<- pivot_wider(tabelanivel1e2, names_from = "VD4002", values_from = "Freq")
tabelanivel1e2$PEA = tabelanivel1e2$`Pessoas ocupadas`+tabelanivel1e2$`Pessoas desocupadas`
tabelanivel1e2$'Taxa de desocupação' = ((tabelanivel1e2$`Pessoas desocupadas`/ tabelanivel1e2$PEA)*100)
tabelanivel1e2<- tabelanivel1e2[-1, ]
tabelanivel1e2<- tabelanivel1e2[-2, ]


tabelanivel3e4<- data.frame(svytable(~VD4002+nivel3e4+V2007, pnadc202012))
tabelanivel3e4<- pivot_wider(tabelanivel3e4, names_from = "VD4002", values_from = "Freq")
tabelanivel3e4$PEA = tabelanivel3e4$`Pessoas ocupadas`+ tabelanivel3e4$`Pessoas desocupadas`
tabelanivel3e4$'Taxa de desocupação' = ((tabelanivel3e4$`Pessoas desocupadas`/ tabelanivel3e4$PEA)*100)
tabelanivel3e4<- tabelanivel3e4[-1, ]
tabelanivel3e4<- tabelanivel3e4[-2, ]


tabelanivel5e6<- data.frame(svytable(~VD4002+nivel5e6+V2007, pnadc202012))
tabelanivel5e6<- pivot_wider(tabelanivel5e6, names_from = "VD4002", values_from = "Freq")
tabelanivel5e6$PEA = tabelanivel5e6$`Pessoas ocupadas`+ tabelanivel5e6$`Pessoas desocupadas`
tabelanivel5e6$'Taxa de desocupação' = ((tabelanivel5e6$`Pessoas desocupadas`/ tabelanivel5e6$PEA)*100)
tabelanivel5e6<- tabelanivel5e6[-1, ]
tabelanivel5e6<- tabelanivel5e6[-2, ]


tabelanivel7<- data.frame(svytable(~VD4002+nivel7+V2007, pnadc202012))
tabelanivel7<- pivot_wider(tabelanivel7, names_from = "VD4002", values_from = "Freq")
tabelanivel7$PEA = tabelanivel7$`Pessoas ocupadas`+ tabelanivel7$`Pessoas desocupadas`
tabelanivel7$'Taxa de desocupação' = ((tabelanivel7$`Pessoas desocupadas`/ tabelanivel7$PEA)*100)
tabelanivel7<- tabelanivel7[-1, ]
tabelanivel7<- tabelanivel7[-2, ]


tabelanivel1e2$nivel1e2 <- factor(tabelanivel1e2$nivel1e2, label=c("Sem instrução e ensino fundamental incompleto"), levels=1)
tabelanivel3e4$nivel3e4 <- factor(tabelanivel3e4$nivel3e4, label=c("Ensino fundamental completo e ensino médio incompleto"), levels=1)
tabelanivel5e6$nivel5e6 <- factor(tabelanivel5e6$nivel5e6, label=c("Ensino médio completo e ensino superior incompleto"), levels=1)
tabelanivel7$nivel7 <- factor(tabelanivel7$nivel7, label=c("Ensino Superior"), levels=1)


colnames(tabelanivel1e2)[1]<- 'Nível de instrução'
colnames(tabelanivel3e4)[1]<-'Nível de instrução'
colnames(tabelanivel5e6)[1]<- 'Nível de instrução'
colnames(tabelanivel7)[1]<- 'Nível de instrução'

colnames(tabelanivel1e2)[2]<- 'Sexo'
colnames(tabelanivel3e4)[2]<- 'Sexo'
colnames(tabelanivel5e6)[2]<- 'Sexo'
colnames(tabelanivel7)[2]<- 'Sexo'

Desocupacao_instrucao_sexo2<- rbind(tabelanivel1e2, tabelanivel3e4, tabelanivel5e6, tabelanivel7)
view(Desocupacao_instrucao_sexo2)

#RESUMO Taxa de desocupação x nível de instrução x sexo - MODO 2 - QUATRO NÍVEIS
Desocupacao_instrucao_sexo_resumo2<- subset(Desocupacao_instrucao_sexo2, select = c("Nível de instrução", "Sexo", "Taxa de desocupação"))
Desocupacao_instrucao_sexo_resumo2<- pivot_wider(Desocupacao_instrucao_sexo_resumo2, names_from = "Nível de instrução", values_from = "Taxa de desocupação")
view(Desocupacao_instrucao_sexo_resumo2)

#Taxa de desocupação x nível de instrução x cor ou raça
tabela20<- data.frame(svytable(~VD4002+nivel1e2+V2010, pnadc202012))
tabela20<- pivot_wider(tabela20, names_from = "VD4002", values_from = "Freq")
tabela20$PEA = tabela20$`Pessoas ocupadas`+tabela20$`Pessoas desocupadas`
tabela20$'Taxa de desocupação' = ((tabela20$`Pessoas desocupadas`/tabela20$PEA)*100)
tabela20<-tabela20[-c(1,3,5,7,9,11),]

tabela21<- data.frame(svytable(~VD4002+ nivel3e4+V2010, pnadc202012))
tabela21<- pivot_wider(tabela21, names_from = "VD4002", values_from = "Freq")
tabela21$PEA = tabela21$`Pessoas ocupadas`+tabela21$`Pessoas desocupadas`
tabela21$'Taxa de desocupação' = ((tabela21$`Pessoas desocupadas`/tabela21$PEA)*100)
tabela21<-tabela21[-c(1,3,5,7,9,11),]

tabela22<- data.frame(svytable(~VD4002+ nivel5e6+V2010, pnadc202012))
tabela22<- pivot_wider(tabela22, names_from = "VD4002", values_from = "Freq")
tabela22$PEA = tabela22$`Pessoas ocupadas`+tabela22$`Pessoas desocupadas`
tabela22$'Taxa de desocupação' = ((tabela22$`Pessoas desocupadas`/ tabela22$PEA)*100)
tabela22<-tabela22[-c(1,3,5,7,9,11),]

tabela23<- data.frame(svytable(~VD4002+ nivel7+V2010, pnadc202012))
tabela23<- pivot_wider(tabela23, names_from = "VD4002", values_from = "Freq")
tabela23$PEA = tabela23$`Pessoas ocupadas`+tabela23$`Pessoas desocupadas`
tabela23$'Taxa de desocupação' = ((tabela23$`Pessoas desocupadas`/ tabela23$PEA)*100)
tabela23<-tabela23[-c(1,3,5,7,9,11),]


tabela20$nivel1e2 <- factor(tabela20$nivel1e2, label=c("Sem instrução e ensino fundamental incompleto"), levels=1)
tabela21$nivel3e4 <- factor(tabela21$nivel3e4, label=c("Ensino fundamental completo e ensino médio incompleto"), levels=1)
tabela22$nivel5e6 <- factor(tabela22$nivel5e6, label=c("Ensino médio completo e ensino superior incompleto"), levels=1)
tabela23$nivel7 <- factor(tabela23$nivel7, label=c("Ensino Superior"), levels=1)

colnames(tabela20)[1]<- 'Nível de instrução'
colnames(tabela21)[1]<-'Nível de instrução'
colnames(tabela22)[1]<- 'Nível de instrução'
colnames(tabela23)[1]<- 'Nível de instrução'

colnames(tabela20)[2]<- 'Cor ou raça'
colnames(tabela21)[2]<-'Cor ou raça'
colnames(tabela22)[2]<- 'Cor ou raça'
colnames(tabela23)[2]<- 'Cor ou raça'

Desocupacao_instrucao_cor_raca<- rbind(tabela20, tabela21, tabela22, tabela23)
view(Desocupacao_instrucao_cor_raca)

Desocupacao_instrucao_cor_raca_resumo<- subset(Desocupacao_instrucao_cor_raca, select = c("Nível de instrução", "Cor ou raça", "Taxa de desocupação"))
Desocupacao_instrucao_cor_raca_resumo<- pivot_wider(Desocupacao_instrucao_cor_raca_resumo, names_from = "Nível de instrução", values_from = "Taxa de desocupação")
view(Desocupacao_instrucao_cor_raca_resumo)



#Taxa de desocupação x idade x cor ou raça
tabela25<- data.frame(svytable(~VD4002+i14a17anos+V2010, pnadc202012))
tabela25<- pivot_wider(tabela25, names_from = "VD4002", values_from = "Freq")
tabela25$PEA = tabela25$`Pessoas ocupadas`+  tabela25$`Pessoas desocupadas`
tabela25$'Taxa de desocupação' = ((tabela25$`Pessoas desocupadas`/ tabela25$PEA)*100)
tabela25<- tabela25[-c(1,3,5,7,9,11),]

tabela26<- data.frame(svytable(~VD4002+i18a24anos+V2010, pnadc202012))
tabela26<- pivot_wider(tabela26, names_from = "VD4002", values_from = "Freq")
tabela26$PEA = tabela26$`Pessoas ocupadas`+  tabela26$`Pessoas desocupadas`
tabela26$'Taxa de desocupação' = ((tabela26$`Pessoas desocupadas`/ tabela26$PEA)*100)
tabela26<- tabela26[-c(1,3,5,7,9,11),]

tabela27<- data.frame(svytable(~VD4002+i25a39anos+V2010, pnadc202012))
tabela27<- pivot_wider(tabela27, names_from = "VD4002", values_from = "Freq")
tabela27$PEA = tabela27$`Pessoas ocupadas`+  tabela27$`Pessoas desocupadas`
tabela27$'Taxa de desocupação' = ((tabela27$`Pessoas desocupadas`/ tabela27$PEA)*100)
tabela27<- tabela27[-c(1,3,5,7,9,11),]

tabela28<- data.frame(svytable(~VD4002+i40a59anos+V2010, pnadc202012))
tabela28<- pivot_wider(tabela28, names_from = "VD4002", values_from = "Freq")
tabela28$PEA = tabela28$`Pessoas ocupadas`+  tabela28$`Pessoas desocupadas`
tabela28$'Taxa de desocupação' = ((tabela28$`Pessoas desocupadas`/ tabela28$PEA)*100)
tabela28<- tabela28[-c(1,3,5,7,9,11),]

tabela29<- data.frame(svytable(~VD4002+i60anosoumais+V2010, pnadc202012))
tabela29<- pivot_wider(tabela29, names_from = "VD4002", values_from = "Freq")
tabela29$PEA = tabela29$`Pessoas ocupadas`+  tabela29$`Pessoas desocupadas`
tabela29$'Taxa de desocupação' = ((tabela29$`Pessoas desocupadas`/ tabela29$PEA)*100)
tabela29<- tabela29[-c(1,3,5,7,9,11),]

tabela25$i14a17anos <- factor(tabela25$i14a17anos, label=c("14 a 17 anos"), levels=1)
tabela26$i18a24anos <- factor(tabela26$i18a24anos, label=c("18 a 24 anos"), levels=1)
tabela27$i25a39anos <- factor(tabela27$i25a39anos, label=c("25 a 39 anos"), levels=1)
tabela28$i40a59anos <- factor(tabela28$i40a59anos, label=c("40 a 59 anos"), levels=1)
tabela29$i60anosoumais <- factor(tabela29$i60anosoumais, label=c("60 anos ou mais"), levels=1)

colnames(tabela25)[2]<- 'Cor ou raça'
colnames(tabela26)[2]<-'Cor ou raça'
colnames(tabela27)[2]<- 'Cor ou raça'
colnames(tabela28)[2]<- 'Cor ou raça'
colnames(tabela29)[2]<- 'Cor ou raça'

colnames(tabela25)[1]<- 'Grupo de Idades'
colnames(tabela26)[1]<-'Grupo de Idades'
colnames(tabela27)[1]<- 'Grupo de Idades'
colnames(tabela28)[1]<- 'Grupo de Idades'
colnames(tabela29)[1]<- 'Grupo de Idades'

Desocupacao_idade_cor_raca<- rbind(tabela25, tabela26, tabela27, tabela28, tabela29)
view(Desocupacao_idade_cor_raca)

#Resumo
Desocupacao_idade_cor_raca_resumo<- subset(Desocupacao_idade_cor_raca, select = c("Grupo de Idades", "Cor ou raça", "Taxa de desocupação"))
Desocupacao_idade_cor_raca_resumo<- pivot_wider(Desocupacao_idade_cor_raca_resumo, names_from = "Grupo de Idades", values_from = "Taxa de desocupação")
view(Desocupacao_idade_cor_raca_resumo)

#Taxa de desocupação x nível de instrução x idade - modo 1 - com 7 níveis 

tabela30<- data.frame(svytable(~VD4002+VD30042+i14a17anos, pnadc202012))
tabela30<- pivot_wider(tabela30, names_from = "VD4002", values_from = "Freq")
tabela30<- tabela30[-c(1,2,3,4,5,6,7),]
tabela30$PEA = tabela30$`Pessoas ocupadas`+  tabela30$`Pessoas desocupadas`
tabela30$'Taxa de desocupação' = ((tabela30$`Pessoas desocupadas`/ tabela30$PEA)*100)

tabela31<- data.frame(svytable(~VD4002+VD30042+i18a24anos, pnadc202012))
tabela31<- pivot_wider(tabela31, names_from = "VD4002", values_from = "Freq")
tabela31<- tabela31[-c(1,2,3,4,5,6,7),]
tabela31$PEA = tabela31$`Pessoas ocupadas`+  tabela31$`Pessoas desocupadas`
tabela31$'Taxa de desocupação' = ((tabela31$`Pessoas desocupadas`/ tabela31$PEA)*100)

tabela32<- data.frame(svytable(~VD4002+VD30042+i25a39anos, pnadc202012))
tabela32<- pivot_wider(tabela32, names_from = "VD4002", values_from = "Freq")
tabela32<- tabela32[-c(1,2,3,4,5,6,7),]
tabela32$PEA = tabela32$`Pessoas ocupadas`+  tabela32$`Pessoas desocupadas`
tabela32$'Taxa de desocupação' = ((tabela32$`Pessoas desocupadas`/ tabela32$PEA)*100)

tabela33<- data.frame(svytable(~VD4002+VD30042+i40a59anos, pnadc202012))
tabela33<- pivot_wider(tabela33, names_from = "VD4002", values_from = "Freq")
tabela33<- tabela33[-c(1,2,3,4,5,6,7),]
tabela33$PEA = tabela33$`Pessoas ocupadas`+  tabela33$`Pessoas desocupadas`
tabela33$'Taxa de desocupação' = ((tabela33$`Pessoas desocupadas`/ tabela33$PEA)*100)


tabela34<- data.frame(svytable(~VD4002+VD30042+i60anosoumais, pnadc202012))
tabela34<- pivot_wider(tabela34, names_from = "VD4002", values_from = "Freq")
tabela34<- tabela34[-c(1,2,3,4,5,6,7),]
tabela34$PEA = tabela34$`Pessoas ocupadas`+  tabela34$`Pessoas desocupadas`
tabela34$'Taxa de desocupação' = ((tabela34$`Pessoas desocupadas`/ tabela34$PEA)*100)


tabela30$i14a17anos <- factor(tabela30$i14a17anos, label=c("14 a 17 anos"), levels=1)
tabela31$i18a24anos <- factor(tabela31$i18a24anos, label=c("18 a 24 anos"), levels=1)
tabela32$i25a39anos <- factor(tabela32$i25a39anos, label=c("25 a 39 anos"), levels=1)
tabela33$i40a59anos <- factor(tabela33$i40a59anos, label=c("40 a 59 anos"), levels=1)
tabela34$i60anosoumais <- factor(tabela34$i60anosoumais, label=c("60 anos ou mais"), levels=1)

colnames(tabela30)[2]<-'Grupo de Idades'
colnames(tabela31)[2]<-'Grupo de Idades'
colnames(tabela32)[2]<-'Grupo de Idades'
colnames(tabela33)[2]<-'Grupo de Idades'
colnames(tabela34)[2]<-'Grupo de Idades'

colnames(tabela30)[1]<- 'Nível de instrução'
colnames(tabela31)[1]<-'Nível de instrução'
colnames(tabela32)[1]<- 'Nível de instrução'
colnames(tabela33)[1]<- 'Nível de instrução'
colnames(tabela34)[1]<- 'Nível de instrução'

Desocupacao_idade_instrucao<- rbind(tabela30, tabela31, tabela32, tabela33, tabela34)

#Resumo
Desocupacao_idade_instrucao_resumo<- subset(Desocupacao_idade_instrucao, select = c("Grupo de Idades", "Nível de instrução", "Taxa de desocupação"))

Desocupacao_idade_instrucao_resumo<- pivot_wider(Desocupacao_idade_instrucao_resumo, names_from = "Nível de instrução", values_from = "Taxa de desocupação")
view(Desocupacao_idade_instrucao_resumo)


#Taxa de desocupação x nível de instrução x idade - modo 2 - com 4 níveis 
tabela40<- data.frame(svytable(~VD4002+nivel1e2+i14a17anos, pnadc202012))
tabela40<- tabela40[-c(1,2,3,4,5,6),]
tabela40<- pivot_wider(tabela40, names_from = "VD4002", values_from = "Freq")
tabela40$PEA = tabela40$`Pessoas ocupadas`+tabela40$`Pessoas desocupadas`
tabela40$'Taxa de desocupação' = ((tabela40$`Pessoas desocupadas`/ tabela40$PEA)*100)

tabela41<- data.frame(svytable(~VD4002+nivel1e2+i18a24anos, pnadc202012))
tabela41<- tabela41[-c(1,2,3,4,5,6),]
tabela41<- pivot_wider(tabela41, names_from = "VD4002", values_from = "Freq")
tabela41$PEA = tabela41$`Pessoas ocupadas`+tabela41$`Pessoas desocupadas`
tabela41$'Taxa de desocupação' = ((tabela41$`Pessoas desocupadas`/ tabela41$PEA)*100)

tabela42<- data.frame(svytable(~VD4002+nivel1e2+i25a39anos, pnadc202012))
tabela42<- tabela42[-c(1,2,3,4,5,6),]
tabela42<- pivot_wider(tabela42, names_from = "VD4002", values_from = "Freq")
tabela42$PEA = tabela42$`Pessoas ocupadas`+tabela42$`Pessoas desocupadas`
tabela42$'Taxa de desocupação' = ((tabela42$`Pessoas desocupadas`/ tabela42$PEA)*100)


tabela43<- data.frame(svytable(~VD4002+nivel1e2+i40a59anos, pnadc202012))
tabela43<- tabela43[-c(1,2,3,4,5,6),]
tabela43<- pivot_wider(tabela43, names_from = "VD4002", values_from = "Freq")
tabela43$PEA = tabela43$`Pessoas ocupadas`+tabela43$`Pessoas desocupadas`
tabela43$'Taxa de desocupação' = ((tabela43$`Pessoas desocupadas`/ tabela43$PEA)*100)

tabela44<- data.frame(svytable(~VD4002+nivel1e2+i60anosoumais, pnadc202012))
tabela44<- tabela44[-c(1,2,3,4,5,6),]
tabela44<- pivot_wider(tabela44, names_from = "VD4002", values_from = "Freq")
tabela44$PEA = tabela44$`Pessoas ocupadas`+tabela44$`Pessoas desocupadas`
tabela44$'Taxa de desocupação' = ((tabela44$`Pessoas desocupadas`/ tabela44$PEA)*100)


tabela45<- data.frame(svytable(~VD4002+nivel3e4+i14a17anos, pnadc202012))
tabela45<- tabela45[-c(1,2,3,4,5,6),]
tabela45<- pivot_wider(tabela45, names_from = "VD4002", values_from = "Freq")
tabela45$PEA = tabela45$`Pessoas ocupadas`+tabela45$`Pessoas desocupadas`
tabela45$'Taxa de desocupação' = ((tabela45$`Pessoas desocupadas`/ tabela45$PEA)*100)

tabela46<- data.frame(svytable(~VD4002+nivel3e4+i18a24anos, pnadc202012))
tabela46<- tabela46[-c(1,2,3,4,5,6),]
tabela46<- pivot_wider(tabela46, names_from = "VD4002", values_from = "Freq")
tabela46$PEA = tabela46$`Pessoas ocupadas`+tabela46$`Pessoas desocupadas`
tabela46$'Taxa de desocupação' = ((tabela46$`Pessoas desocupadas`/ tabela46$PEA)*100)

tabela47<- data.frame(svytable(~VD4002+nivel3e4+i25a39anos, pnadc202012))
tabela47<- tabela47[-c(1,2,3,4,5,6),]
tabela47<- pivot_wider(tabela47, names_from = "VD4002", values_from = "Freq")
tabela47$PEA = tabela47$`Pessoas ocupadas`+tabela47$`Pessoas desocupadas`
tabela47$'Taxa de desocupação' = ((tabela47$`Pessoas desocupadas`/ tabela47$PEA)*100)

tabela48<- data.frame(svytable(~VD4002+nivel3e4+i40a59anos, pnadc202012))
tabela48<- tabela48[-c(1,2,3,4,5,6),]
tabela48<- pivot_wider(tabela48, names_from = "VD4002", values_from = "Freq")
tabela48$PEA = tabela48$`Pessoas ocupadas`+tabela48$`Pessoas desocupadas`
tabela48$'Taxa de desocupação' = ((tabela48$`Pessoas desocupadas`/ tabela48$PEA)*100)

tabela49<- data.frame(svytable(~VD4002+nivel3e4+i60anosoumais, pnadc202012))
tabela49<- tabela49[-c(1,2,3,4,5,6),]
tabela49<- pivot_wider(tabela49, names_from = "VD4002", values_from = "Freq")
tabela49$PEA = tabela49$`Pessoas ocupadas`+tabela49$`Pessoas desocupadas`
tabela49$'Taxa de desocupação' = ((tabela49$`Pessoas desocupadas`/ tabela49$PEA)*100)

tabela50<- data.frame(svytable(~VD4002+nivel5e6+i14a17anos, pnadc202012))
tabela50<- tabela50[-c(1,2,3,4,5,6),]
tabela50<- pivot_wider(tabela50, names_from = "VD4002", values_from = "Freq")
tabela50$PEA = tabela50$`Pessoas ocupadas`+tabela50$`Pessoas desocupadas`
tabela50$'Taxa de desocupação' = ((tabela50$`Pessoas desocupadas`/ tabela50$PEA)*100)

tabela51<- data.frame(svytable(~VD4002+nivel5e6+i18a24anos, pnadc202012))
tabela51<- tabela51[-c(1,2,3,4,5,6),]
tabela51<- pivot_wider(tabela51, names_from = "VD4002", values_from = "Freq")
tabela51$PEA = tabela51$`Pessoas ocupadas`+tabela51$`Pessoas desocupadas`
tabela51$'Taxa de desocupação' = ((tabela51$`Pessoas desocupadas`/ tabela51$PEA)*100)

tabela52<- data.frame(svytable(~VD4002+nivel5e6+i25a39anos, pnadc202012))
tabela52<- tabela52[-c(1,2,3,4,5,6),]
tabela52<- pivot_wider(tabela52, names_from = "VD4002", values_from = "Freq")
tabela52$PEA = tabela52$`Pessoas ocupadas`+tabela52$`Pessoas desocupadas`
tabela52$'Taxa de desocupação' = ((tabela52$`Pessoas desocupadas`/ tabela52$PEA)*100)

tabela53<- data.frame(svytable(~VD4002+nivel5e6+i40a59anos, pnadc202012))
tabela53<- tabela53[-c(1,2,3,4,5,6),]
tabela53<- pivot_wider(tabela53, names_from = "VD4002", values_from = "Freq")
tabela53$PEA = tabela53$`Pessoas ocupadas`+tabela53$`Pessoas desocupadas`
tabela53$'Taxa de desocupação' = ((tabela53$`Pessoas desocupadas`/ tabela53$PEA)*100)

tabela54<- data.frame(svytable(~VD4002+nivel5e6+i60anosoumais, pnadc202012))
tabela54<- tabela54[-c(1,2,3,4,5,6),]
tabela54<- pivot_wider(tabela54, names_from = "VD4002", values_from = "Freq")
tabela54$PEA = tabela54$`Pessoas ocupadas`+tabela54$`Pessoas desocupadas`
tabela54$'Taxa de desocupação' = ((tabela54$`Pessoas desocupadas`/ tabela54$PEA)*100)

tabela55<- data.frame(svytable(~VD4002+nivel7+i14a17anos, pnadc202012))
tabela55<- tabela55[-c(1,2,3,4,5,6),]
tabela55<- pivot_wider(tabela55, names_from = "VD4002", values_from = "Freq")
tabela55$PEA = tabela55$`Pessoas ocupadas`+tabela55$`Pessoas desocupadas`
tabela55$'Taxa de desocupação' = ((tabela55$`Pessoas desocupadas`/ tabela55$PEA)*100)

tabela56<- data.frame(svytable(~VD4002+nivel7+i18a24anos, pnadc202012))
tabela56<- tabela56[-c(1,2,3,4,5,6),]
tabela56<- pivot_wider(tabela56, names_from = "VD4002", values_from = "Freq")
tabela56$PEA = tabela56$`Pessoas ocupadas`+tabela56$`Pessoas desocupadas`
tabela56$'Taxa de desocupação' = ((tabela56$`Pessoas desocupadas`/ tabela56$PEA)*100)

tabela57<- data.frame(svytable(~VD4002+nivel7+i25a39anos, pnadc202012))
tabela57<- tabela57[-c(1,2,3,4,5,6),]
tabela57<- pivot_wider(tabela57, names_from = "VD4002", values_from = "Freq")
tabela57$PEA = tabela57$`Pessoas ocupadas`+tabela57$`Pessoas desocupadas`
tabela57$'Taxa de desocupação' = ((tabela57$`Pessoas desocupadas`/ tabela57$PEA)*100)


tabela58<- data.frame(svytable(~VD4002+nivel7+i40a59anos, pnadc202012))
tabela58<- tabela58[-c(1,2,3,4,5,6),]
tabela58<- pivot_wider(tabela58, names_from = "VD4002", values_from = "Freq")
tabela58$PEA = tabela58$`Pessoas ocupadas`+tabela58$`Pessoas desocupadas`
tabela58$'Taxa de desocupação' = ((tabela58$`Pessoas desocupadas`/ tabela58$PEA)*100)

tabela59<- data.frame(svytable(~VD4002+nivel7+i60anosoumais, pnadc202012))
tabela59<- tabela59[-c(1,2,3,4,5,6),]
tabela59<- pivot_wider(tabela59, names_from = "VD4002", values_from = "Freq")
tabela59$PEA = tabela59$`Pessoas ocupadas`+tabela59$`Pessoas desocupadas`
tabela59$'Taxa de desocupação' = ((tabela59$`Pessoas desocupadas`/ tabela59$PEA)*100)

tabela40$i14a17anos <- factor(tabela40$i14a17anos, label=c("14 a 17 anos"), levels=1)
tabela41$i18a24anos <- factor(tabela41$i18a24anos, label=c("18 a 24 anos"), levels=1)
tabela42$i25a39anos <- factor(tabela42$i25a39anos, label=c("25 a 39 anos"), levels=1)
tabela43$i40a59anos <- factor(tabela43$i40a59anos, label=c("40 a 59 anos"), levels=1)
tabela44$i60anosoumais <- factor(tabela44$i60anosoumais, label=c("60 anos ou mais"), levels=1)
tabela45$i14a17anos <- factor(tabela45$i14a17anos, label=c("14 a 17 anos"), levels=1)
tabela46$i18a24anos <- factor(tabela46$i18a24anos, label=c("18 a 24 anos"), levels=1)
tabela47$i25a39anos <- factor(tabela47$i25a39anos, label=c("25 a 39 anos"), levels=1)
tabela48$i40a59anos <- factor(tabela48$i40a59anos, label=c("40 a 59 anos"), levels=1)
tabela49$i60anosoumais <- factor(tabela49$i60anosoumais, label=c("60 anos ou mais"), levels=1)
tabela50$i14a17anos <- factor(tabela50$i14a17anos, label=c("14 a 17 anos"), levels=1)
tabela51$i18a24anos <- factor(tabela51$i18a24anos, label=c("18 a 24 anos"), levels=1)
tabela52$i25a39anos <- factor(tabela52$i25a39anos, label=c("25 a 39 anos"), levels=1)
tabela53$i40a59anos <- factor(tabela53$i40a59anos, label=c("40 a 59 anos"), levels=1)
tabela54$i60anosoumais <- factor(tabela54$i60anosoumais, label=c("60 anos ou mais"), levels=1)
tabela55$i14a17anos <- factor(tabela55$i14a17anos, label=c("14 a 17 anos"), levels=1)
tabela56$i18a24anos <- factor(tabela56$i18a24anos, label=c("18 a 24 anos"), levels=1)
tabela57$i25a39anos <- factor(tabela57$i25a39anos, label=c("25 a 39 anos"), levels=1)
tabela58$i40a59anos <- factor(tabela58$i40a59anos, label=c("40 a 59 anos"), levels=1)
tabela59$i60anosoumais <- factor(tabela59$i60anosoumais, label=c("60 anos ou mais"), levels=1)

tabela40$nivel1e2 <- factor(tabela40$nivel1e2, label=c("Sem instrução e ensino fundamental incompleto"), levels=1)
tabela41$nivel1e2 <- factor(tabela41$nivel1e2, label=c("Sem instrução e ensino fundamental incompleto"), levels=1)
tabela42$nivel1e2 <- factor(tabela42$nivel1e2, label=c("Sem instrução e ensino fundamental incompleto"), levels=1)
tabela43$nivel1e2 <- factor(tabela43$nivel1e2, label=c("Sem instrução e ensino fundamental incompleto"), levels=1)
tabela44$nivel1e2 <- factor(tabela44$nivel1e2, label=c("Sem instrução e ensino fundamental incompleto"), levels=1)
tabela45$nivel3e4 <- factor(tabela45$nivel3e4, label=c("Ensino fundamental completo e ensino médio incompleto"), levels=1)
tabela46$nivel3e4 <- factor(tabela46$nivel3e4, label=c("Ensino fundamental completo e ensino médio incompleto"), levels=1)
tabela47$nivel3e4 <- factor(tabela47$nivel3e4, label=c("Ensino fundamental completo e ensino médio incompleto"), levels=1)
tabela48$nivel3e4 <- factor(tabela48$nivel3e4, label=c("Ensino fundamental completo e ensino médio incompleto"), levels=1)
tabela49$nivel3e4 <- factor(tabela49$nivel3e4, label=c("Ensino fundamental completo e ensino médio incompleto"), levels=1)
tabela50$nivel5e6 <- factor(tabela50$nivel5e6, label=c("Ensino médio completo e ensino superior incompleto"), levels=1)
tabela51$nivel5e6 <- factor(tabela51$nivel5e6, label=c("Ensino médio completo e ensino superior incompleto"), levels=1)
tabela52$nivel5e6 <- factor(tabela52$nivel5e6, label=c("Ensino médio completo e ensino superior incompleto"), levels=1)
tabela53$nivel5e6 <- factor(tabela53$nivel5e6, label=c("Ensino médio completo e ensino superior incompleto"), levels=1)
tabela54$nivel5e6 <- factor(tabela54$nivel5e6, label=c("Ensino médio completo e ensino superior incompleto"), levels=1)
tabela55$nivel7 <- factor(tabela55$nivel7, label=c("Ensino Superior"), levels=1)
tabela56$nivel7 <- factor(tabela56$nivel7, label=c("Ensino Superior"), levels=1)
tabela57$nivel7 <- factor(tabela57$nivel7, label=c("Ensino Superior"), levels=1)
tabela58$nivel7 <- factor(tabela58$nivel7, label=c("Ensino Superior"), levels=1)
tabela59$nivel7 <- factor(tabela59$nivel7, label=c("Ensino Superior"), levels=1)


colnames(tabela40)[2]<-'Grupo de Idades'
colnames(tabela41)[2]<-'Grupo de Idades'
colnames(tabela42)[2]<-'Grupo de Idades'
colnames(tabela43)[2]<-'Grupo de Idades'
colnames(tabela44)[2]<-'Grupo de Idades'
colnames(tabela45)[2]<-'Grupo de Idades'
colnames(tabela46)[2]<-'Grupo de Idades'
colnames(tabela47)[2]<-'Grupo de Idades'
colnames(tabela48)[2]<-'Grupo de Idades'
colnames(tabela49)[2]<-'Grupo de Idades'
colnames(tabela50)[2]<-'Grupo de Idades'
colnames(tabela51)[2]<-'Grupo de Idades'
colnames(tabela52)[2]<-'Grupo de Idades'
colnames(tabela53)[2]<-'Grupo de Idades'
colnames(tabela54)[2]<-'Grupo de Idades'
colnames(tabela55)[2]<-'Grupo de Idades'
colnames(tabela56)[2]<-'Grupo de Idades'
colnames(tabela57)[2]<-'Grupo de Idades'
colnames(tabela58)[2]<-'Grupo de Idades'
colnames(tabela59)[2]<-'Grupo de Idades'

colnames(tabela40)[1]<- 'Nível de instrução'
colnames(tabela41)[1]<-'Nível de instrução'
colnames(tabela42)[1]<-'Nível de instrução'
colnames(tabela43)[1]<-'Nível de instrução'
colnames(tabela44)[1]<-'Nível de instrução'
colnames(tabela45)[1]<-'Nível de instrução'
colnames(tabela46)[1]<-'Nível de instrução'
colnames(tabela47)[1]<-'Nível de instrução'
colnames(tabela48)[1]<-'Nível de instrução'
colnames(tabela49)[1]<-'Nível de instrução'
colnames(tabela50)[1]<-'Nível de instrução'
colnames(tabela51)[1]<-'Nível de instrução'
colnames(tabela52)[1]<-'Nível de instrução'
colnames(tabela53)[1]<-'Nível de instrução'
colnames(tabela54)[1]<-'Nível de instrução'
colnames(tabela55)[1]<-'Nível de instrução'
colnames(tabela56)[1]<-'Nível de instrução'
colnames(tabela57)[1]<-'Nível de instrução'
colnames(tabela58)[1]<-'Nível de instrução'
colnames(tabela59)[1]<-'Nível de instrução'

Desocupacao_idade_nivel_instrucao2<- rbind(tabela40, tabela41, tabela42, tabela43, tabela44,
                                           tabela45, tabela46, tabela47, tabela48, tabela49,
                                           tabela50, tabela51, tabela52, tabela53, tabela54,
                                           tabela55, tabela56, tabela57, tabela58, tabela59)



