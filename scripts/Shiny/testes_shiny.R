









install.packages("shinyjs")
library(rsconnect)
rsconnect::deployApp('H:/FJP/scripts/Shiny/PIB/PIB_MG/')

library(rvest)
pag_fjp <- read_html("http://fjp.mg.gov.br/produto-interno-bruto-pib-de-minas-gerais/")
url <- pag_fjp %>% html_element(xpath = "//div[@id='elementor-tab-content-1428']/ul/li[2]/a") %>% html_attr(name = 'href')



page <- readLines(paste("https://apisidra.ibge.gov.br/desctabapi.aspx?c=", "5457"),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)
pos <- grep('NomeNivelterritorial', page)
territorios_nomes <- vector('list', length(pos))
mypattern <- 'NomeNivelterritorial_([^<]*)</span><span'
datalines = grep(mypattern,page[pos],value=TRUE)
getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
gg = gregexpr(mypattern,datalines)
matches = mapply(getexpr,datalines,gg)
for(i in c(1:length(territorios_nomes))){
  territorios_nomes[[i]] <- strsplit(gsub(mypattern,'\\1', matches[[i]]), split = ">", fixed = TRUE)[[1]][2]
}
pos <- grep('IdNivelterritorial', page)
territorios_valores <- vector('list', length(pos))
mypattern <- 'IdNivelterritorial_([^<]*)</span><span'
datalines = grep(mypattern,page[pos],value=TRUE)
gg = gregexpr(mypattern,datalines)
matches = mapply(getexpr,datalines,gg)
for(i in c(1:length(territorios_valores))){
  territorios_valores[[i]] <- strsplit(gsub(mypattern,'\\1', matches[[i]]), split = ">", fixed = TRUE)[[1]][2]
}

choices <- territorios_valores 
names(choices) <- territorios_nomes

page2 <- readLines(paste("https://apisidra.ibge.gov.br/LisUnitTabAPI.aspx?c=", "5457", "&n=", "2", "&i=P"),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)
page3 <- readLines(paste("https://apisidra.ibge.gov.br/LisUnitTabAPI.aspx?c=", "5457", "&n=", "3", "&i=P"),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)
page4 <- readLines(paste("https://apisidra.ibge.gov.br/LisUnitTabAPI.aspx?c=", "5457", "&n=", "4", "&i=P"),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)
page5 <- readLines(paste("https://apisidra.ibge.gov.br/LisUnitTabAPI.aspx?c=", "5457", "&n=", "5", "&i=P"),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)
page6 <- readLines(paste("https://apisidra.ibge.gov.br/LisUnitTabAPI.aspx?c=", "5457", "&n=", "6", "&i=P"),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)



page2 <- readLines(paste("https://apisidra.ibge.gov.br/LisUnitTabAPI.aspx?c=", input$tabela, "&n=", input$territorios_consulta, "&i=P"),  warn = FALSE, encoding = "UTF-8", ok = TRUE, skipNul = FALSE)


num_colunas <- length(grep('<th>', page6))
pos <- grep('<td>', page6)

mypattern <- '<td>([^<]*)</td><td'
datalines = grep(mypattern,page6[pos],value=TRUE)
getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
gg = gregexpr(mypattern,datalines)
matches = mapply(getexpr,datalines,gg)
unidades_nomes <- vector('list', length(matches))
for(i in c(1:length(unidades_nomes))){
  unidades_nomes[i] <- gsub(mypattern,'\\1', matches[i])
}

pos <- grep('<td align', page2)
mypattern <- 'color="Red">([^<]*)</font></td>'
datalines = grep(mypattern,page2[pos],value=TRUE)
getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
gg = gregexpr(mypattern,datalines)
matches = mapply(getexpr,datalines,gg)
unidades_valores <- vector('list', length(matches))
for(i in c(1:length(unidades_valores))){
  unidades_valores[i] <- gsub(mypattern,'\\1', matches[i])
}


unidades <- unidades_valores
names(unidades) <- unidades_nomes

setores <- c("Agropecuária",
             "Agricultura",
             "Pecuária",
             "Prod. florestal, pesca e aquicultura",
             "Indústria",
             "Indústria extrativa",
             "Indústrias de transformação",
             "Eletricidade e gás, água, esgoto",
             "Construção",
             "Serviços",
             "Comércio de veículos automotores",
             "Transporte, armazenagem e correio",
             "Serviços de alojamento e alimentação",
             "Serviços de informação e comunicação",
             "Atividades financeiras",
             "Atividades imobiliárias",
             "Atividades profissionais",
             "Administração, educação, saúde",
             "Educação e saúde mercantis",
             "Artes, cultura, esporte",
             "Serviços domésticos"
)

library("readxl")
library(tidyverse)
library(highcharter)
require("dplyr")
library("viridisLite")
library(rlist)

arquivo_pib_tab8 <- read_excel("H:\\FJP\\scripts\\Anexo-estatistico-PIB-MG-anual-2010-2018.xlsx", sheet = "Tabela 8")
colnames(arquivo_pib_tab8)[1] <- "setores_nomes"
arquivo_pib_tab8[6:26, 1] <- setores

participacao_valor_bruto_producao <- arquivo_pib_tab8[c(6:26), c(1:10)]
colnames(participacao_valor_bruto_producao)[c(2:10)] <- as.character(c(2010:2018))
participacao_valor_bruto_producao <- participacao_valor_bruto_producao %>% gather(key = 'ano', value = 'valor', -setores_nomes)
participacao_valor_bruto_producao[, -1] <- lapply(participacao_valor_bruto_producao[, -1], as.numeric) # make all columns numeric

participacao_consumo_intermediario <- arquivo_pib_tab8[c(6:26), c(1, 12:20)]
colnames(participacao_consumo_intermediario)[c(2:10)] <- as.character(c(2010:2018))
participacao_consumo_intermediario <- participacao_consumo_intermediario %>% gather(key = 'ano', value = 'valor', -setores_nomes)
participacao_consumo_intermediario[, -1] <- lapply(participacao_consumo_intermediario[, -1], as.numeric) # make all columns numeric

participacao_valor_adicionado <- arquivo_pib_tab8[c(6:26), c(1, 20:28)]
colnames(participacao_valor_adicionado)[c(2:10)] <- as.character(c(2010:2018))
participacao_valor_adicionado <- participacao_valor_adicionado %>% gather(key = 'ano', value = 'valor', -setores_nomes)
participacao_valor_adicionado[, -1] <- lapply(participacao_valor_adicionado[, -1], as.numeric) # make all columns numeric



ci_corrente <- file_tab6[c(7:27), c(1,2, 6, 10, 14, 18, 22, 26, 30, 34)]
ci_var_volume <- file_tab6[c(7:27), c(1, 3, 7, 11, 15, 19, 23, 27, 31)]
ci_var_preco <- file_tab6[c(7:27), c(1, 5, 9, 13, 17, 21, 25, 29, 33)]
ci_particip <- file_tab8[c(6:26), c(1, 11:19)]

ci_corrente[, 1] <-  setores
colnames(ci_corrente)[c(1:10)] <- c("setor", as.character(c(2010:2018)))
ci_corrente <- ci_corrente %>% gather(key = 'ano', value = 'valor', -setor)
ci_corrente[, -1] <- lapply(ci_corrente[, -1], as.numeric) # make all columns numeric

ci_var_volume[, 1] <-  setores
colnames(ci_var_volume)[c(1:9)] <- c("setor", as.character(c(2011:2018)))
ci_var_volume <- ci_var_volume %>% gather(key = 'ano', value = 'valor', -setor)
ci_var_volume[, -1] <- lapply(ci_var_volume[, -1], as.numeric) # make all columns numeric
aux <- data.frame(setores, 2010, NA)
names(aux) <- c("setor", "ano", "valor")
ci_var_volume <- rbind(aux, ci_var_volume)

ci_var_preco[, 1] <-  setores
colnames(ci_var_preco)[c(1:9)] <- c("setor", as.character(c(2011:2018)))
ci_var_preco <- ci_var_preco %>% gather(key = 'ano', value = 'valor', -setor)
ci_var_preco[, -1] <- lapply(ci_var_preco[, -1], as.numeric) # make all columns numeric
aux <- data.frame(setores, 2010, NA)
names(aux) <- c("setor", "ano", "valor")
ci_var_preco <- rbind(aux, ci_var_preco)

ci_particip[, 1] <-  setores
colnames(ci_particip)[c(1:10)] <- c("setor", as.character(c(2010:2018)))
ci_particip <- ci_particip %>% gather(key = 'ano', value = 'valor', -setor)
ci_particip[, -1] <- lapply(ci_particip[, -1], as.numeric) # make all columns numeric

ci <- cbind(ci_corrente, ci_var_volume[3], ci_var_preco[3],  ci_particip[, 3])
colnames(ci) <- c("setor", "ano", "corrente", "var_volume", "var_preco", "particip")

valor_corrente <- cbind(vbp_corrente, ci_corrente[3], vab_corrente[3])
colnames(valor_corrente) <- c("setor", "ano", "vbp", "ci", "vab")

valor_corrente <- pivot_longer(valor_corrente, cols = c(3:5), names_to = "resultado", values_to = "valor")

file_tab10 <- read.xlsx("H:\\FJP\\scripts\\Anexo-estatistico-PIB-MG-anual-2010-2018.xlsx", sheetIndex = 10)

valor_corrente <- cbind(file_tab5[c(7:27), c(1,2)], file_tab6[c(7:27), c(2)], file_tab7[c(7:27), c(2)])

vab_corrente <- file_tab7[c(7:27), c(1,2, 6, 10, 14, 18, 22, 26, 30, 34)]
vab_var_volume <- file_tab7[c(7:27), c(1, 3, 7, 11, 15, 19, 23, 27, 31)]
vab_var_preco <- file_tab7[c(7:27), c(1, 5, 9, 13, 17, 21, 25, 29, 33)]
vab_particip <- file_tab8[c(6:26), c(1, 20:28)]
vab_particip_br <- file_tab10[c(6:26), c(1:10)]

vab_corrente[, 1] <-  setores
colnames(vab_corrente)[c(1:10)] <- c("setor", as.character(c(2010:2018)))
vab_corrente <- vab_corrente %>% gather(key = 'ano', value = 'valor', -setor)
vab_corrente[, -1] <- lapply(vab_corrente[, -1], as.numeric) # make all columns numeric

vab_var_volume[, 1] <-  setores
colnames(vab_var_volume)[c(1:9)] <- c("setor", as.character(c(2011:2018)))
vab_var_volume <- vab_var_volume %>% gather(key = 'ano', value = 'valor', -setor)
vab_var_volume[, -1] <- lapply(vab_var_volume[, -1], as.numeric) # make all columns numeric
aux <- data.frame(setores, 2010, NA)
names(aux) <- c("setor", "ano", "valor")
vab_var_volume <- rbind(aux, vab_var_volume)

vab_var_preco[, 1] <-  setores
colnames(vab_var_preco)[c(1:9)] <- c("setor", as.character(c(2011:2018)))
vab_var_preco <- vab_var_preco %>% gather(key = 'ano', value = 'valor', -setor)
vab_var_preco[, -1] <- lapply(vab_var_preco[, -1], as.numeric) # make all columns numeric
aux <- data.frame(setores, 2010, NA)
names(aux) <- c("setor", "ano", "valor")
vab_var_preco <- rbind(aux, vab_var_preco)

vab_particip[, 1] <-  setores
colnames(vab_particip)[c(1:10)] <- c("setor", as.character(c(2010:2018)))
vab_particip <- vab_particip %>% gather(key = 'ano', value = 'valor', -setor)
vab_particip[, -1] <- lapply(vab_particip[, -1], as.numeric) # make all columns numeric

vab_particip_br[, 1] <-  setores
colnames(vab_particip_br)[c(1:10)] <- c("setor", as.character(c(2010:2018)))
vab_particip_br <- vab_particip_br %>% gather(key = 'ano', value = 'valor', -setor)
vab_particip_br[, -1] <- lapply(vab_particip_br[, -1], as.numeric) # make all columns numeric

vab <- cbind(vab_corrente, vab_var_volume[3], vab_var_preco[3],  vab_particip[3], vab_particip_br[3] )
colnames(vab) <- c("setor", "ano", "corrente", "var_volume", "var_preco", "particip", "particip_br")

vbp_corrente <- file_tab5[c(7:27), c(1,2, 6, 10, 14, 18, 22, 26, 30, 34)]
vbp_var_volume <- file_tab5[c(7:27), c(1, 3, 7, 11, 15, 19, 23, 27, 31)]
vbp_var_preco <- file_tab5[c(7:27), c(1, 5, 9, 13, 17, 21, 25, 29, 33)]
vbp_particip <- file_tab8[c(6:26), c(1:10)]
setores <- c("Agropecuária",
             "Agricultura",
             "Pecuária",
             "Prod. florestal",
             "Indústria",
             "Ind. extrativa",
             "Ind. transformação",
             "Energia e saneamento",
             "Construção",
             "Serviços",
             "Comércio",
             "Transporte",
             "Alojamento e alimentação",
             "Informação e comunicação",
             "Ativ. financeiras",
             "Ativ. imobiliárias",
             "Serv. pres. empresas",
             "APU",
             "Educação e saúde",
             "Cultura e esporte",
             "Serv. domésticos"
)
setor_index <- c(2:4, 6:9, 11:21)
area_index <- c(1, 5, 10)
setor <- setores[setor_index]
area <- setores[area_index]

tipoResutados <- c("Valor Bruto da Produção" = 'VBP', "Consumo Intermediário" = 'CI', "Valor Adicionado Bruto" = 'VAB')
aspectos2 <- c("Valor corrente" = 'vc', "Var. volume" = 'vv', "Var. preço" = 'vp', "Part. valor corrente em MG" = 'pmg' , "Part. valor corrente no Brasil" = 'pbr')
tiposGraficos <- c("Linha" = 'linha', "Barra"= 'barra', "Barra Empilhado" = 'barra_empilhado', "Pizza" = 'pizza')
vbp_corrente[, 1] <-  setores
colnames(vbp_corrente)[c(1:10)] <- c("setor", as.character(c(2010:2018)))
vbp_corrente <- vbp_corrente %>% gather(key = 'ano', value = 'valor', -setor)
vbp_corrente[, -1] <- lapply(vbp_corrente[, -1], as.numeric) # make all columns numeric

vbp_var_volume[, 1] <-  setores
colnames(vbp_var_volume)[c(1:9)] <- c("setor", as.character(c(2011:2018)))
vbp_var_volume <- vbp_var_volume %>% gather(key = 'ano', value = 'valor', -setor)
vbp_var_volume[, -1] <- lapply(vbp_var_volume[, -1], as.numeric) # make all columns numeric
aux <- data.frame(setores, 2010, NA)
names(aux) <- c("setor", "ano", "valor")
vbp_var_volume <- rbind(aux, vbp_var_volume)

vbp_var_preco[, 1] <-  setores
colnames(vbp_var_preco)[c(1:9)] <- c("setor", as.character(c(2011:2018)))
vbp_var_preco <- vbp_var_preco %>% gather(key = 'ano', value = 'valor', -setor)
vbp_var_preco[, -1] <- lapply(vbp_var_preco[, -1], as.numeric) # make all columns numeric
aux <- data.frame(setores, 2010, NA)
names(aux) <- c("setor", "ano", "valor")
vbp_var_preco <- rbind(aux, vbp_var_preco)

vbp_particip[, 1] <-  setores
colnames(vbp_particip)[c(1:10)] <- c("setor", as.character(c(2010:2018)))
vbp_particip <- vbp_particip %>% gather(key = 'ano', value = 'valor', -setor)
vbp_particip[, -1] <- lapply(vbp_particip[, -1], as.numeric) # make all columns numeric

vbp <- cbind(vbp_corrente, vbp_var_volume[3], vbp_var_preco[3],  vbp_particip[, 3])
colnames(vbp) <- c("setor", "ano", "corrente", "var_volume", "var_preco", "particip")

ds2 <- subset(vbp[c(1,2, 6)], (ano >= 2010 & ano <= 2018) & !(setor %in% c("Comércio", "Transporte")))
a <- ds2 %>% 
  group_by(ano) %>% 
  summarise(particip = sum(particip))
names(a) <- c('x', 'y')
  

lsetores <- c("Agropecuária","Agricultura")
anos <- c(2010:2015)
d <- subset(participacao_valor_adicionado, setores_nomes %in% lsetores & ano %in% anos)
ds <- lapply(lsetores, function(x){
  d <- subset(participacao_valor_adicionado, setores_nomes %in% x)
  data = data.frame(x = d$ano,
                   y = d$valor)
                   
})
hc2 <- highchart() %>% 
  hc_yAxis(title = list(text = "Participação (%)")) %>%
  hc_xAxis(title = list(text = "Ano"))
for (k in 1:length(ds)) {
  hc2 <- hc2 %>%
    hc_add_series(ds[[k]], name = lsetores[k])
}
hc2

highchart() %>%
  hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>%
  hc_add_series_list(ds)

input$setor
library("googleVis")
library("ggplot2")
library("data.table")
setor <- setores[1:2]
dados <- participacao_valor_adicionado %>% filter(setores_nomes %in% setor)
dados_t <- transpose(dados[-1])
colnames(dados_t) <- dados[, 1]
rownames(dados_t) <- colnames(dados)

p <- participacao_valor_adicionado %>% filter(setores_nomes  %in% "Atividades")[, 2:3] 


myplot <- ggplot(participacao_valor_adicionado) +
  geom_line(aes(x = ano, y = valor, color = setores_nomes))+
  labs(x = "Ano", 
     y = "Participação (%)", 
     title = "Participação no valor adicionado")
myplot %+% subset(participacao_valor_adicionado, setores_nomes %in% c("Construção"))


else{
  updateCheckboxGroupInput(
    session, 'spec_areas_aspecto_fixo ', choices = area,
    selected = if(input$spec_aspecto_fixo_tudo) area 
  )
}

# Load dataset from github
data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/3_TwoNumOrdered.csv", header=T)
data$date <- as.Date(data$date)

renderGvis({myplot})

# Download data
dataset <- read.csv("http://www.electionresources.org/de/data/2013.csv", header = FALSE)
# Add the column names
colnames(dataset) <- c("Region", 
                       "Election", 
                       "Party",
                       "Votes_First_Vote",
                       "Percent_First_Vote",
                       "Direct_Seats",
                       "Votes_Second_Vote",
                       "Percent_Second_Vote",
                       "List_Seats",
                       "Total_Seats")
# Keep only results for Germany overall and remove general statistics
dataset <- subset(dataset, Region == "DE" & !(Party %in% c("Registered Electors", "Voters", "Blank or Invalid Ballots", "Valid Votes")))
# Remove "Christian Democratic Union/Christian Social Union" because it just aggregates CDU and CSU
dataset <- subset(dataset, Party != "Christian Democratic Union/Christian Social Union")
# Remove unnecessary levels
dataset$Party <- factor(dataset$Party)

# Rename parties
require(plyr)
dataset$Party <- mapvalues(dataset$Party, 
                           from = c("Christian Democratic Union (CDU)", 
                                    "Christian Social Union (CSU)", 
                                    "Social Democratic Party of Germany (SPD)", 
                                    "The Left. (DIE LINKE)", 
                                    "Alliance 90/The Greens (GR&Uuml;NE)", 
                                    "Free Democratic Party (F.D.P.)", 
                                    "Alternative for Germany (AfD)", 
                                    "Pirate Party of Germany (PIRATEN)", 
                                    "National Democratic Party of Germany (NPD)", 
                                    "Free Voters (FREIE W&Auml;HLER)", 
                                    "Others"), 
                           to = c("CDU", 
                                  "CSU", 
                                  "SPD", 
                                  "DIE LINKE", 
                                  "GRÜNE", 
                                  "FDP", 
                                  "AfD", 
                                  "PIRATEN", 
                                  "NPD",
                                  "FREIE WÄHLER",
                                  "Others"))

# Create simple pie chart with correct colors
require(highcharter)
highchart() %>% 
  hc_chart(type = "pie") %>% 
  myhc_add_series_labels_values(labels = dataset$Party, values = dataset$Votes_First_Vote, text = dataset$Party)
library("highcharter")


library(highcharter)
A <- c("a", "b", "c", "d")
B <- c(4, 6, 9, 2)
C <- c(23, 26, 13, 15)
df <- data.frame(A, B, C)

# A modified version of the "hc_add_series_labels_values" function
# The "text" input is now available
myhc_add_series_labels_values <- function (hc, labels, values, text, colors = NULL, ...) 
{
  assertthat::assert_that(is.highchart(hc), is.numeric(values), 
                          length(labels) == length(values))
  df <- dplyr::data_frame(name = labels, y = values, text=text)
  if (!is.null(colors)) {
    assert_that(length(labels) == length(colors))
    df <- mutate(df, color = colors)
  }
  ds <- list_parse(df)
  hc <- hc %>% hc_add_series(data = ds, ...)
  hc
}

library(highcharter)

anos_pieplot_prod <- c(2010, 2018)
nomes_producao <- c("Produção", "Impostos produtos", "Consumo Intermediário", "Valor adicionado bruto")

h <-highchart() %>% 
  hc_chart(type = "column") %>%
  hc_plotOptions(column = list(stacking = "normal")) %>%
  hc_xAxis(categories = c(anos_pieplot_prod[1] : anos_pieplot_prod[2])) %>%
  hc_add_series(name= nomes_producao[1],
                data = subset(contas_economicas, contas %in% nomes_producao[1] & (ano >= anos_pieplot_prod[1] & ano <= anos_pieplot_prod[2]))$valor,
                stack = "Produção") %>%
  hc_add_series(name=nomes_producao[2],
                data = subset(contas_economicas, contas %in% nomes_producao[2] & (ano >= anos_pieplot_prod[1] & ano <= anos_pieplot_prod[2]))$valor,
                stack = "Produção") %>%
  hc_add_series(name=nomes_producao[3],
                data = subset(contas_economicas, contas %in% nomes_producao[3] & (ano >= anos_pieplot_prod[1] & ano <= anos_pieplot_prod[2]))$valor,
                stack = "Consumo") %>%
  hc_add_series(name=nomes_producao[4],
                data = subset(contas_economicas, contas %in% nomes_producao[4] & (ano >= anos_pieplot_prod[1] & ano <= anos_pieplot_prod[2]))$valor,
                stack = "Consumo")
h
bs.table = data.frame(
  Closing.Date = paste(2013:2017, 12, sep = "/"),
  Non.Current.Assets = c(13637344, 14075507, 14578093, 10911628, 10680998),
  Current.Assets = c(13078654, 12772388, 14226181, 10205708, 10950779),
  Non.Current.Liabilities = c(9376243, 8895126, 9715914, 9810157, 13493110),
  Current.Liabilities = c(5075985, 4963856, 5992229, 8859263, 4094183)
)

highchart() %>% 
  hc_chart(type = "column") %>%
  hc_plotOptions(column = list(stacking = "normal")) %>%
  hc_xAxis(categories = bs.table$Closing.Date) %>%
  hc_add_series(name="Non Current Assets",
                data = bs.table$Non.Current.Assets,
                stack = "Assets") %>%
  hc_add_series(name="Current Assets",
                data = bs.table$Current.Assets,
                stack = "Assets") %>%
  hc_add_series(name="Non Current Liabilities",
                data = bs.table$Non.Current.Liabilities,
                stack = "Liabilities") %>%
  hc_add_series(name="Current Liabilities",
                data = bs.table$Current.Liabilities,
                stack = "Liabilities") %>%
  hc_add_theme(hc_theme_ft())


d <- subset(contas_economicas, (ano >= 2010 & ano <= 2018))
d[d$contas == 'Produção', 'valor'] <- d[d$contas == 'Produção', 'valor']/(d[d$contas == 'Produção', 'valor']+d[d$contas == 'Impostos produtos', 'valor'])


ds <- lapply(nomes_producao, function(x){
  
  d <- subset(contas_economicas, contas %in% x & (ano >= anos_pieplot_prod[1] & ano <= anos_pieplot_prod[2]))
  data = data.frame(x = d$ano,
                    y = d$valor)
  
})
h <- highchart() %>% 
  hc_size(width = 600, height = 400) %>%
  hc_yAxis(title = list(text = "Contas ")) %>%
  hc_xAxis(title = list(text = "Ano"))
for (k in 1:length(ds)) {
  h <- h %>%
    hc_add_series(ds[[k]], name = nomes_producao[k])
}
h

# Set the "text" input in myhc_add_series_labels_values
# point.text is now available inside pointFormat of hc_tooltip
highchart() %>% 
  hc_chart(type = "pie", data=df) %>% 
  myhc_add_series_labels_values(labels=A, values=B, text=C) %>% 
  hc_tooltip(crosshairs=TRUE, borderWidth=5, sort=TRUE, shared=TRUE, table=TRUE,
             pointFormat=paste('<br><b>A: {point.percentage:.1f}%</b><br>C: {point.text}')) %>%
  hc_title(text="ABC", margin=20, style=list(color="#144746", useHTML=TRUE)) 


lsetores_pie_chart <- c("Pecuária","Agricultura")
areas <- c("Serviços", "Agropecuária", "Indústria" )
ano_pie_chart <- c(2018)
d <- subset(participacao_valor_bruto_producao, !(setores_nomes %in% areas) & ano %in% ano_pie_chart & !(setores_nomes %in% lsetores_pie_chart))
demais <- sum(d$valor )

labels_pi_chart <- c(lsetores_pie_chart, "Outros")
valores_pi_chart <- c(subset(participacao_valor_bruto_producao, setores_nomes %in% lsetores_pie_chart & ano %in% ano_pie_chart)$valor, demais)

highchart() %>% 
  hc_chart(type = "pie") %>% 
  myhc_add_series_labels_values(labels = labels_pi_chart, values = valores_pi_chart, text = labels_pi_chart)


library(readxl)
library(XLConnect)
library("openxlsx")
temp = tempfile(fileext = ".xlsx")
dataURL <- "http://fjp.mg.gov.br/wp-content/uploads/2020/09/Anexo-estatistico-PIB-MG-anual-2010-2018.xlsx"
download.file(dataURL, destfile=temp, mode='wb')
file_tab1 <- read_excel(temp, sheet =  1)
file_tab4 <- read.xlsx("H:\\FJP\\scripts\\Anexo-estatistico-PIB-MG-anual-2010-2018.xlsx", sheetIndex = 4)
file_tab5 <- read.xlsx("H:\\FJP\\scripts\\Anexo-estatistico-PIB-MG-anual-2010-2018.xlsx", sheetIndex = 5)
file_tab6 <- read.xlsx("H:\\FJP\\scripts\\Anexo-estatistico-PIB-MG-anual-2010-2018.xlsx", sheetIndex = 6)
file_tab7 <- read.xlsx("H:\\FJP\\scripts\\Anexo-estatistico-PIB-MG-anual-2010-2018.xlsx", sheetIndex = 7)
file_tab8 <- read.xlsx("H:\\FJP\\scripts\\Anexo-estatistico-PIB-MG-anual-2010-2018.xlsx", sheetIndex = 8)

colnames(file_tab1)[1] <- "contas_economicas"
contas_economicas <- file_tab1[c(7,8,10,17,18,19,20,21,11), c(1:10)]
nomes <- c("Produção", "Impostos produtos", "Consumo Intermediário", "Remuneração", "Salários", "contribuições", "Impostos produção", "Excedente", "Valor adicionado bruto")
contas_economicas[, 1] <-  nomes
colnames(contas_economicas)[c(1:10)] <- c("contas", as.character(c(2010:2018)))
contas_economicas <- contas_economicas %>% gather(key = 'ano', value = 'valor', -contas)
contas_economicas[, -1] <- lapply(contas_economicas[, -1], as.numeric) # make all columns numeric


pib_percapita <- file_tab4[c(5,9,12), c(1:10)]
nomes <- c("PIB", "População", "PIB per capita")
pib_percapita[, 1] <-  nomes
colnames(pib_percapita)[c(1:10)] <- c("especificacao", as.character(c(2010:2018)))
pib_percapita <- pib_percapita %>% gather(key = 'ano', value = 'valor', -especificacao)
pib_percapita[, -1] <- lapply(pib_percapita[, -1], as.numeric) # make all columns numeric



vbp_corrente <- file_tab5[c(7:27), c(1,2, 6, 10, 14, 18, 22, 26, 30, 34)]
vbp_var_volume <- file_tab5[c(7:27), c(1, 3, 7, 11, 15, 19, 23, 27, 31)]
vbp_var_preco <- file_tab5[c(7:27), c(1, 5, 9, 13, 17, 21, 25, 29, 33)]
vbp_particip <- file_tab8[c(6:26), c(1:10)]
nomes <- c("Agropecuária",
           "Agricultura",
           "Pecuária",
           "Prod. florestal",
           "Indústria",
           "Ind. extrativa",
           "Ind. transformação",
           "Energia e saneamento",
           "Construção",
           "Serviços",
           "Comércio",
           "Transporte",
           "Alojamento e alimentação",
           "Informação e comunicação",
           "Ativ. financeiras",
           "Ativ. imobiliárias",
           "Serv. pres. empresas",
           "APU",
           "Educação e saúde",
           "Cultura e esporte",
           "Serv. domésticos"
)
vbp_corrente[, 1] <-  nomes
colnames(vbp_corrente)[c(1:10)] <- c("setor", as.character(c(2010:2018)))
vbp_corrente <- vbp_corrente %>% gather(key = 'ano', value = 'valor', -setor)
vbp_corrente[, -1] <- lapply(vbp_corrente[, -1], as.numeric) # make all columns numeric

vbp_var_volume[, 1] <-  nomes
colnames(vbp_var_volume)[c(1:9)] <- c("setor", as.character(c(2011:2018)))
vbp_var_volume <- vbp_var_volume %>% gather(key = 'ano', value = 'valor', -setor)
vbp_var_volume[, -1] <- lapply(vbp_var_volume[, -1], as.numeric) # make all columns numeric
aux <- data.frame(nomes, 2010, NA)
names(aux) <- c("setor", "ano", "valor")
vbp_var_volume <- rbind(aux, vbp_var_volume)

vbp_var_preco[, 1] <-  nomes
colnames(vbp_var_preco)[c(1:9)] <- c("setor", as.character(c(2011:2018)))
vbp_var_preco <- vbp_var_preco %>% gather(key = 'ano', value = 'valor', -setor)
vbp_var_preco[, -1] <- lapply(vbp_var_preco[, -1], as.numeric) # make all columns numeric
aux <- data.frame(nomes, 2010, NA)
names(aux) <- c("setor", "ano", "valor")
vbp_var_preco <- rbind(aux, vbp_var_preco)

vbp_particip[, 1] <-  nomes
colnames(vbp_particip)[c(1:10)] <- c("setor", as.character(c(2010:2018)))
vbp_particip <- vbp_particip %>% gather(key = 'ano', value = 'valor', -setor)
vbp_particip[, -1] <- lapply(vbp_particip[, -1], as.numeric) # make all columns numeric

vbp <- cbind(vbp_corrente, vbp_var_volume[3], vbp_var_preco[3],  vbp_particip[, 3])
colnames(vbp) <- c("setor", "ano", "corrente", "var_volume", "var_preco", "particip")



df <- data.frame(
  total_inbox = c(2, 3, 4, 5, 6),
  total_volume = c(30, 30, 30, 30, 30),
  total_users = c(300, 400, 20, 340, 330),
  received_dt = c("20180202", "20180204", "20180206", "20180210", "20180212"),
  isp = "ProviderXY"
)

df$inbox_rate <- df$total_inbox / df$total_volume
df$inbox_rate <- round((df$inbox_rate*100),0)
df$received_dt <- as.character(df$received_dt)
df$received_dt <- as.Date(df$received_dt, "%Y%m%d")
df <- df[order(df$received_dt),]

espec <- c("PIB","PIB per capita", "População")
ds <- lapply(espec, function(x){
  d <- subset(pib_percapita, especificacao %in% x & (ano >= 2010 & ano <= 2018))
  data = data.frame(x = d$ano,
                    y = d$valor)
  
})


hc <- highchart()%>%
  hc_xAxis(categories = c(2010: 2018), title = list(text = "Ano")) %>%
  hc_yAxis_multiples(list(title = list(text = "PIB (1000000 R$)"), opposite = FALSE, showEmpty= FALSE),
                     list(title = list(text = "PIB per capita (R$)"),opposite = FALSE),
                     list(title = list(text = "População"), opposite = TRUE) ) %>%
  hc_plotOptions(column = list(stacking = "normal")) %>%
  hc_add_series(ds[[3]],type="column", name=espec[3], yAxis=2) %>%
  hc_add_series(ds[[1]],type="line", name=espec[1], yAxis=0) %>%
  hc_add_series(ds[[2]],type="line", name=espec[2], yAxis=1) %>%
  hc_tooltip(crosshairs = TRUE,
             borderWidth = 5,
             sort = FALSE,
             table = TRUE)
  
  

hc
hc <- highchart()%>%
  hc_xAxis(type = "datetime", labels = list(format = '{value:%m/%d}')) %>%
  hc_yAxis_multiples(list(title = list(text = "IPR"),labels=list(format = '{value}%'),min=0,
                          max=100,showFirstLabel = TRUE,showLastLabel=TRUE,opposite = FALSE),
                     list(title = list(text = "Total Subscribers"),min=0,max = max(df$total_users),
                          labels = list(format = "{value}"),showLastLabel = FALSE, opposite = TRUE)) %>%
  hc_plotOptions(column = list(stacking = "normal")) %>%
  hc_add_series(df,type="column",hcaes(x=received_dt,y=total_users,group=isp),yAxis=1) %>%
  hc_add_series(df,type="line",hcaes(x=received_dt,y=inbox_rate,group=isp))

hc

conditionalPanel(
  condition = "input.selected == 'Contas Econômicas'",  
  radioButtons("setor_ou_area", label = NULL, choices = c("Setores", "Grande área"), inline = TRUE),
  conditionalPanel(
    condition = "input.setor_ou_area == 'Setores'",
    checkboxGroupInput("setor", "Selecione o setor", c(setores, 'Todos'))
  ),
  conditionalPanel(
    condition = "input.setor_ou_area == 'Grande área'",
    checkboxGroupInput("grande_area", "Selecione a área", c(areas, 'Todos'))
  ),
),

fluidRow(box(htmlOutput("titulo1"),width=12,background='light-blue')),   
fluidRow(box(highchartOutput('linePlot'), height=420,width = 12)),#,background='white')),
fluidRow(conditionalPanel(
  condition = "input.selected == 'Participação das atividades'",
  box(radioButtons("aspecto", label = NULL, aspectos, inline = TRUE, width = '90%', selected = "Valor Adicionado (%)"), width = 12,)
),
)
),
tabItem(tabName = "grafico2",    
        
        fluidRow(box(htmlOutput("titulo2"),width=12,background='light-blue')),   
        fluidRow(box(highchartOutput('piePlot'), height=420,width = 12)),#,background='white')),
        
)

else if(input$aspecto == "Valor Bruto da Produção (%)"){
  ds <- lapply(input$setor, function(x){
    d <- subset(participacao_valor_bruto_producao, setores_nomes %in% x & (ano >= input$escolha_anos[1] & ano <= input$escolha_anos[2]))
    data = data.frame(x = d$ano,
                      y = d$valor)
    
  })
  h <- highchart() %>% 
    hc_yAxis(title = list(text = "Participação (%)")) %>%
    hc_xAxis(title = list(text = "Ano"))
  for (k in 1:length(ds)) {
    h <- h %>%
      hc_add_series(ds[[k]], name = input$setor[k])
  }
  h
  
  
}
else if(input$aspecto == "Consumo Intermediário (%)"){
  ds <- lapply(input$setor, function(x){
    d <- subset(participacao_consumo_intermediario, setores_nomes %in% x & (ano >= input$escolha_anos[1] & ano <= input$escolha_anos[2]))
    data = data.frame(x = d$ano,
                      y = d$valor)
    
  })
  h <- highchart() %>% 
    hc_yAxis(title = list(text = "Participação (%)")) %>%
    hc_xAxis(title = list(text = "Ano"))
  for (k in 1:length(ds)) {
    h <- h %>%
      hc_add_series(ds[[k]], name = input$setor[k])
  }
  h
}
}
else if(!is_empty(input$grande_area)){
  if(input$aspecto == "Valor Adicionado (%)"){
    ds <- lapply(input$grande_area, function(x){
      d <- subset(participacao_valor_adicionado, setores_nomes %in% x & (ano >= input$escolha_anos[1] & ano <= input$escolha_anos[2]))
      data = data.frame(x = d$ano,
                        y = d$valor)
      
    })
    h <- highchart() %>% 
      hc_yAxis(title = list(text = "Participação (%)")) %>%
      hc_xAxis(title = list(text = "Ano"))
    for (k in 1:length(ds)) {
      h <- h %>%
        hc_add_series(ds[[k]], name = input$setor[k])
    }
    h
  }
  else if(input$aspecto == "Valor Bruto da Produção (%)"){
    ds <- lapply(input$grande_area, function(x){
      d <- subset(participacao_valor_bruto_producao, setores_nomes %in% x & (ano >= input$escolha_anos[1] & ano <= input$escolha_anos[2]))
      data = data.frame(x = d$ano,
                        y = d$valor)
      
    })
    h <- highchart() %>% 
      hc_yAxis(title = list(text = "Participação (%)")) %>%
      hc_xAxis(title = list(text = "Ano"))
    for (k in 1:length(ds)) {
      h <- h %>%
        hc_add_series(ds[[k]], name = input$setor[k])
    }
    h
  }
  else if(input$aspecto == "Consumo Intermediário (%)"){
    ds <- lapply(input$grande_area, function(x){
      d <- subset(participacao_consumo_intermediario, setores_nomes %in% x & (ano >= input$escolha_anos[1] & ano <= input$escolha_anos[2]))
      data = data.frame(x = d$ano,
                        y = d$valor)
      
    })
    h <- highchart() %>% 
      hc_yAxis(title = list(text = "Participação (%)")) %>%
      hc_xAxis(title = list(text = "Ano"))
    for (k in 1:length(ds)) {
      h <- h %>%
        hc_add_series(ds[[k]], name = input$setor[k])
    }
    h
  }
  
}


output$piePlot_renda <- renderHighchart({
  if(input$selected == "Contas Econômicas"){
    if(!is_empty(input$espec_prod)){
      ano_pie_chart <- input$anos_pieplot_prod
      d <- subset(contas_economicas, ano %in% ano_pie_chart & !(contas %in% input$espec_prod) & !(contas %in% nomes_renda))
      demais <- sum(d$valor)
      
      labels_pi_chart <- c(input$espec_prod, "Outros")
      valores_pi_chart <- c(subset(contas_economicas, contas %in% input$espec_prod & ano %in% ano_pie_chart)$valor, demais)
      
      highchart() %>% 
        hc_chart(type = "pie") %>% 
        myhc_add_series_labels_values(labels = labels_pi_chart, values = valores_pi_chart, text = labels_pi_chart)
    }
  }
})
