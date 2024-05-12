#https://djalmapessoa.github.io/adac/introduc.html


# instalação da library anamco
#library(devtools)
#install_github("djalmapessoa/anamco")

# Leitura dos dados
library(anamco)
ppv_dat <- ppv
# Características dos dados da PPV
dim(ppv_dat)

names(ppv_dat)

# Adiciona variáveis ao arquivo ppv_dat
ppv_dat <- transform(ppv_dat, 
                     analf1 = ((v04a01 == 2 | v04a02 == 2) & (v02a08 >= 7 & v02a08 <= 14)) * 1, 
                     analf2 = ((v04a01 == 2 | v04a02 == 2) & (v02a08 >14)) * 1, 
                     faixa1 = (v02a08 >= 7 & v02a08 <= 14) *1, 
                     faixa2 = (v02a08 > 14) * 1)
#str(ppv_dat)

# Carrega o pacote survey
library(survey)
# Cria objeto contendo dados e metadados sobre a estrutura do plano amostral
ppv_plan <- svydesign(ids = ~nsetor, strata = ~estratof, data = ppv_dat, 
                      nest = TRUE, weights = ~pesof)

ppv_se_plan <- subset(ppv_plan, regiao == "Sudeste")

svytotal(~analf1, ppv_se_plan, deff = TRUE)

svytotal(~analf2, ppv_se_plan, deff = TRUE)

svyratio(~analf1, ~faixa1, ppv_se_plan)

svyby(~analf1, ~regiao, ppv_plan, svytotal, deff = TRUE)