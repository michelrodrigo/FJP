library(dplyr)
library(data.table)
library(xlsx)
library(rio)

setwd('H:/FJP/scripts')

dados1 <- as.data.frame(readxl::read_excel("Tradutor v01r04 (22.08.19).xlsx", sheet = 1))
#dados1 <- as.data.frame(readxl::read_excel("teste2.xlsx", sheet = 1))

dados1[is.na(dados1)] <- 0                 ## substituindo NA's por zero
dados1 <- dados1[!dados1$"NCM" == 0,]      ## EXCUINDO OS ZEROS NA PRIMEIRA COLUNA
dim(dados1)

#testes
f = fread("xaa.txt", sep = ";", quote ="") 



qdv <- 1
files1 <- paste0("xa",letters[1:qdv],".txt")
g <- paste0("dados",1:qdv,".txt")
tamanho1 <- NULL
tamanho2 <- NULL
soma_f <- NULL
soma_f_novo <- NULL


for(i in 1:qdv){
  f = fread(files1[i], sep = ";", quote ="") 
  f_novo <- f %>% filter((V16>=6100 & V16<=6123 | V16>=6250 & V16<=6258 | V16>=6300 & V16<=6307 | V16>=6350 & V16<=6360 |
                            V16>=6400 & V16<=6404 | V16>=6550 & V16<=6551 | V16>=6650 & V16<=6656)) %>% filter(!(V19 %in% c("-1", "0000-0/00", "NULL") | 
                                                                                                                   V6 == 4))
  tamanho1[i] <- dim(f)[1]
  tamanho2[i] <- dim(f_novo)[1]
  soma_f[i] <- sum(f$V24)
  soma_f_novo[i] <- sum(f_novo$V24) 
  f_novo <- data.table(f_novo)
  v <- f_novo[,sum(V24), by=data.table(V8,V12,V15,V19,V21)]
  write.table(v, g[i], row.names = FALSE)
  rm(f); rm(v); rm(f_novo); gc(reset = T)
}

Porcentagem_quantidade <- paste0(round(100 * sum(tamanho2)/sum(tamanho1),3),"%")
Porcentagem_quantidade
Porcentagem_soma <- paste0(round(100 * sum(soma_f_novo)/sum(soma_f),3),"%")
Porcentagem_soma

files <- paste0("dados", 1:qdv, ".txt")
df_files <- lapply(files, fread)                   ## IMPORTANDO OS "DADOS" 
df_files <-  do.call(df_files, what = "rbind")     ## EMPILHANDO OS "DADOS"

sapply(paste0("dados", 1:qdv, ".txt"), unlink)  ## EXCLUINDO OS "DADOS" DA PASTA

memory.size()
gc(reset = T)

df_files <- data.table(df_files)                         ## COLOCANDO OS DADOS EMPILHADOS COMO DATA.TABLE
df_files <- df_files[,sum(V1), by=data.table(V8,V12,V15,V19,V21)]  ## AGRUPANDO OS DADOS  ## BANCO "LIMPO"  ####################################
df_files <- group_by(df_files,V8,V12,V15) %>% summarise(Total=sum(V1))

######## EMITENTE ############

f_final <- data.frame(dados1[,1])           # CRIANDO UM NOVO DATA.FRAME COM A COLUNA "V15" (CODIGO NCM
names(f_final)[1] <- "Codigo NCM"                     # MUDANDO O NOME DA COLUNA 
g1 <- c("AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB",   # 27 ESTADOS
        "PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO")                               
for(i in 1:length(g1)){                                       #CRIANDO A TABELA DE CADA MUNICIPIO COMO EMITENTE 
  for(j in 1:length(g1)){
    g <- df_files %>% filter(V8 == g1[i]) %>%  filter(V12 == g1[j])
    f_final <- left_join(f_final, g[,c("V15", "Total")],by = c("Codigo NCM" = "V15")) 
  }
}
f_final <- as.data.frame(f_final)  ## TRANSFORMANDO A TABELA FINAL PARA DATA.FRAME 
dim(f_final)  ## FOI CRIADA UMA TABELA COM 197 COLUNAS (1ª COM O CODIGO E 14 PARA CADA EMITENTE)


######## DESTINATARIO ############

f_final_dest <- data.frame(dados1[,1])           # CRIANDO UM NOVO DATA.FRAME COM A COLUNA "V15" (CODIGO NCM
names(f_final_dest)[1] <- "Codigo NCM"                     # MUDANDO O NOME DA COLUNA 
g1 <- c("AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB",   # 27 ESTADOS
        "PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO")                               
for(i in 1:length(g1)){                                       #CRIANDO A TABELA DE CADA MUNICIPIO COMO EMITENTE 
  for(j in 1:length(g1)){
    g <- df_files %>% filter(V12 == g1[i]) %>%  filter(V8 == g1[j])
    f_final_dest <- left_join(f_final_dest, g[,c("V15", "Total")],by = c("Codigo NCM" = "V15")) 
  }
}
f_final_dest <- as.data.frame(f_final_dest)  ## TRANSFORMANDO A TABELA FINAL PARA DATA.FRAME 
dim(f_final_dest)  ## FOI CRIADA UMA TABELA COM 197 COLUNAS (1ª COM O CODIGO E 14 PARA CADA EMITENTE)


#################### EMITENTE 

f_final2 <- data.frame(sort(unique(df_files$V15)))           # CRIANDO UM NOVO DATA.FRAME COM A COLUNA "V15" (CODIGO NCM

names(f_final2)[1] <- "Codigo NCM"                     # MUDANDO O NOME DA COLUNA 
g1 <- c("AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB",   # 27 ESTADOS
        "PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO")                               
for(i in 1:length(g1)){                                       #CRIANDO A TABELA DE CADA MUNICIPIO COMO EMITENTE 
  for(j in 1:length(g1)){
    g <- df_files %>% filter(V8 == g1[i]) %>%  filter(V12 == g1[j])
    f_final2 <- left_join(f_final2, g[,c("V15", "Total")],by = c("Codigo NCM" = "V15")) 
  }
}
f_final2 <- as.data.frame(f_final2)  ## TRANSFORMANDO A TABELA FINAL PARA DATA.FRAME 
dim(f_final2)  ## FOI CRIADA UMA TABELA COM 197 COLUNAS (1ª COM O CODIGO E 14 PARA CADA EMITENTE)

#################### DESTINATÁRIO 

f_final3 <- data.frame(sort(unique(df_files$V15)))  # CRIANDO UM NOVO DATA.FRAME COM A COLUNA "V15"        


names(f_final3)[1] <- "Codigo NCM"                     # MUDANDO O NOME DA COLUNA 
g1 <- c("AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB",   # 27 ESTADOS
        "PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO")                               
for(i in 1:length(g1)){                                       #CRIANDO A TABELA DE CADA MUNICIPIO COMO EMITENTE 
  for(j in 1:length(g1)){
    g <- df_files %>% filter(V12 == g1[i]) %>%  filter(V8 == g1[j])
    f_final3 <- left_join(f_final3, g[,c("V15", "Total")],by = c("Codigo NCM" = "V15")) 
  }
}
f_final3 <- as.data.frame(f_final3)  ## TRANSFORMANDO A TABELA FINAL PARA DATA.FRAME 
dim(f_final3)  ## FOI CRIADA UMA TABELA COM 197 COLUNAS (1ª COM O CODIGO E 14 PARA CADA EMITENTE)

soma1 <- colSums(f_final[2:730],na.rm=TRUE)
soma2 <- colSums(f_final2[2:730],na.rm=TRUE)
soma3 <- colSums(f_final3[2:730],na.rm=TRUE)
soma4 <- colSums(f_final_dest[2:730],na.rm=TRUE)

Nas <- round(soma2 - soma1,3)
Nas <- c("soma_NA's_faltantes",Nas)
f_final[dim(f_final)[1]+1,] <- Nas

Nas1 <- round(soma3 - soma4,3)
Nas1 <- c("soma_NA's_faltantes",Nas1)
f_final_dest[dim(f_final_dest)[1]+1,] <- Nas1

##### CODIGOS PARA NOMEAR AS ABAS E AS COLUNAS DE CADA ABA

q <- c("AC","AL","AM","AP","BA","CE","DF","ES","GO","MA","MG","MS","MT","PA","PB",   # 27 ESTADOS
       "PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO")
r <- rep(q[1],27)
for(i in 2:length(q)){
  r <- c(r,rep(q[i],27))
}
q1 <- 1:27
q2 <- paste0(r,"_",q)
names(f_final)[2:730] <- q2
names(f_final_dest)[2:730] <- q2

w <- seq(2,730,27)
w1 <- seq(28,730,27)

####### TRANSFPRMANDO PARA NUMERICO

for(i in 2:dim(f_final)[2]){
  f_final[,i] <- as.numeric(f_final[,i])
}


for(i in 2:dim(f_final_dest)[2]){
  f_final_dest[,i] <- as.numeric(f_final_dest[,i])
}

######  SEPARANDO AS 14 TABELAS  ## EMITENTE
datas <- list()
for(i in 1:27){
  datas[[i]] <- f_final[,c(1,w[i]:w1[i])]
}


## SEPARANDO AS 14 TABELAS  ## DESTINATARIO
datas_dest <- list()
for(i in 1:27){
  datas_dest[[i]] <- f_final_dest[,c(1,w[i]:w1[i])]
}

## NOMEANDO AS ABAS  

nomes <- paste0("base_",q)
for(i in 1:27){
  names(datas)[i] <- nomes[i]
  names(datas_dest)[i] <- nomes[i]
}

## EXPORTANDO PARA O EXCEL ## EMITENTE

export(datas, file = "dados_final_emitente_2016_6_NCM.xlsx")

## EXPORTANDO PARA O EXCEL ## EMITENTE

export(datas_dest, file = "dados_final_destinatario_2016_6_NCM.xlsx")

