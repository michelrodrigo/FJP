

entrada  <- "https://sidra.ibge.gov.br/geratabela?format=us.csv&name=tabela1407.csv&terr=N&rank=-&query=t/1407/n1/all/v/312/p/all/c12354/all/c11066/allxt/l/,,p%2Bt%2Bc12354%2Bv%2Bc11066"


#' Realiza a importação da tabela
tab_1407 <- fread(entrada,
                  integer64 = "numeric",
                  na.strings = c('"-"','"X"'),
                  colClasses = c(list("factor" = c(1:5))),
                  encoding = "UTF-8")

entrada  <- "https://sidra.ibge.gov.br/geratabela?format=us.csv&name=tabela1418.csv&terr=N&rank=-&query=t/1418/n1/all/v/863,1128,368/p/all/c11070/allxt/l/,,p%2Bt%2Bc11070%2Bv"


#' Realiza a importação da tabela
tab_1418 <- fread(entrada,
                  integer64 = "numeric",
                  na.strings = c('"-"','"X"'),
                  colClasses = c(list("factor" = c(1:5))),
                  encoding = "UTF-8")

entrada  <- "https://sidra.ibge.gov.br/geratabela?format=us.csv&name=tabela1400.csv&terr=N&rank=-&query=t/1400/n1/all/v/501,866/p/all/c11070/allxt/l/,,p%2Bt%2Bc11070%2Bv"


#' Realiza a importação da tabela
tab_1400 <- fread(entrada,
                  integer64 = "numeric",
                  na.strings = c('"-"','"X"'),
                  colClasses = c(list("factor" = c(1:5))),
                  encoding = "UTF-8")

entrada  <- "https://sidra.ibge.gov.br/geratabela?format=us.csv&name=tabela1399.csv&terr=N&rank=-&query=t/1399/n1/all/v/643,314/p/all/c11065/allxt/c319/allxt/l/,,p%2Bt%2Bc11065%2Bv%2Bc319"


#' Realiza a importação da tabela
tab_1399 <- fread(entrada,
                  integer64 = "numeric",
                  na.strings = c('"-"','"X"'),
                  colClasses = c(list("factor" = c(1:5))),
                  encoding = "UTF-8")


entrada <- "https://sidra.ibge.gov.br/geratabela?format=us.csv&name=tabela1092.csv&terr=N&rank=-&query=/t/1092/n3/31/v/284/p/last%205/c12716/allxt/c18/992/c12529/118225/l/,,p%2Bt%2Bc12716%2Bv%2Bc18%2Bc12529"

#' Realiza a importação da tabela
tab_1092 <- fread(entrada,
                  integer64 = "numeric",
                  na.strings = c('"-"','"X"'),
                  colClasses = c(list("factor" = c(1:5))),
                  encoding = "UTF-8")