library("xml2")
library("rvest")

url <- "http://fjp.mg.gov.br/publicacoes"

pagina <- xml2::read_html(url)

#Obtendo os tipo de publicações e seus respectivos links


pagina |> html_element("figcaption")
pagina |> html_elements("figcaption")
pagina |> html_elements("widget-image-caption")
pagina |> html_elements("figcaption") |> html_text2()

https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/

url <- "https://www.imdb.com/search/title/?count=100&release_date=2022,2022&title_type=feature"
https://selectorgadget.com/
  https://try.jsoup.org/

pagina <- read_html(url)

#rank
pagina |> html_elements('.lister-item-header .text-primary')
pagina |>  html_elements(".text-primary")
pagina |>  html_elements(".text-primary") |> html_text2()
pagina |>  html_elements(xpath = "//span[@class='text-primary']") |> html_text2()

rank <- as.numeric(pagina |>  html_elements(".text-primary") |> html_text2())

#nomes
pagina |> html_elements('.lister-item-header a')
pagina |> html_elements('.lister-item-header a') |> html_text2()
pagina |> html_elements(xpath = "//h3[@class='lister-item-header']//a") |> html_text2()

#descrição
pagina |> html_elements('.text-muted')
pagina |> html_elements('p.text-muted') |> html_text2()

pagina |> html_elements(xpath = "//p[@class='text-muted']") |> html_text2()

#gênero
pagina |> html_elements('.text-muted')
pagina |> html_elements('p.text-muted') |> html_text2()

pagina |> html_elements(xpath = "//*[@class='genre']") |> html_text2()
pagina |> html_elements(xpath = "//span[@class='genre']") |> html_text2()

pagina |> html_elements(xpath = "//div/strong") |> html_text2()
pagina |> html_elements(xpath = "h3") |> html_text2()

library(stringr)
anos <- pagina |> html_elements(xpath = "//h3/span[2]") |> html_text2()
anos <- as.numeric( unlist(regmatches(anos, gregexpr("[[:digit:]]+", anos))))
nomes <- pagina |> html_elements(xpath = "//h3/a") |> html_text2()

duracao <- rep(NA, length(nomes))
for(i in c(1:length(nomes))){
  duracao[i] <- pagina |> html_element(xpath = paste0("//h3/a[contains(text(),'", nomes[i],"')]/../../*/*[@class='runtime']")) |> html_text2()
}
duracao <- pagina |> html_elements(xpath = "//*[@class='runtime']") |> html_text2()

dur <- apply(nomes, 1, ...)

generos <- pagina |> html_elements(xpath = "//*[@class='genre']") |> html_text2()
generos <- strsplit(generos, ", ")

pagina |> html_elements(xpath = "//h3/a") |> html_attr('href')

f <-cbind(rank, anos, nomes, generos)



url <- "http://voos.infraero.gov.br/hstvoos/RelatorioPortal.aspx"
url <- "https://pt.wikipedia.org/wiki/Lista_de_prefeitos_de_Belo_Horizonte"
pagina <- read_html(url)

t <- pagina |> html_element(xpath = "//table[@class='wikitable']") |> html_table(header = TRUE, trim = TRUE)

url <- "http://fjp.mg.gov.br/produto-interno-bruto-pib-de-minas-gerais/"
pagina <- read_html(url)

pagina |> html_elements(xpath = "//*[contains(text(), 'PIB anual')]/../../*/*/*/strong") |> html_text2()



link <- pagina |> html_elements(xpath = "//*[contains(text(), 'Bases de dados')]/../../*/*/li[2]/a") |> html_attr('href')
arquivo <- rio::import(link)


url <- "http://tabnet.datasus.gov.br/cgi/dhdat.exe?bd_pni/dpnibr.def"
url <- "http://tabnet.datasus.gov.br/cgi/tabcgi.exe?sim/cnv/pext10mg.def"
pagina <- read_html(url)

pagina |> html_elements("option")
