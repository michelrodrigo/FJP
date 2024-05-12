library("xml2")
library("rvest")

url <- "https://www.imdb.com/search/title/?count=10&release_date=2021,2021&title_type=feature"

pagina <- read_html(url)

nomes <- pagina |> html_elements(xpath = "//h3/a") |> html_text2()

pagina |> html_elements(xpath = "//h3/span[2]") |> html_text2()
rank <- as.numeric(pagina |> html_elements(xpath = "//h3/span[@class='lister-item-index unbold text-primary']") |> html_text2())

anos <- pagina |> html_elements(xpath = "//h3/span[@class='lister-item-year text-muted unbold']") |> html_text2()
anos <- as.numeric(unlist(regmatches(anos, gregexpr("[[:digit:]]+", anos))))

generos <- pagina |> html_elements(xpath = "//*[@class='genre']") |> html_text2()
generos <- strsplit(generos, ", ")

duracao <- pagina |> html_elements(xpath = "//*[@class='runtime']") |> html_text2()
duracao <- as.numeric(unlist(regmatches(duracao, gregexpr("[[:digit:]]+", duracao))))

pagina |> html_elements(xpath = "//*[contains(text(), 'Sing 2')]/../../*/*[@class='runtime']") |> html_text2()

links <- pagina |> html_elements(xpath = "//h3/a") |> html_attr('href')

filmes <- cbind(nomes, rank, anos, generos, duracao, links)

#---------

url <- "https://www.imdb.com/search/title/?count=20&title_type=feature&release_date=2015-12-31,2021-01-01&sort=user_rating,desc"

pagina <- read_html(url)


nomes <- pagina |> html_elements(xpath = "//h3/a") |> html_text2()
pagina |> html_elements(xpath = "//*[@class='runtime']") |> html_text2()

duracao <- rep(NA, length(nomes))
for(i in c(1:length(nomes))){
  duracao[i] <- pagina |> html_element(xpath = paste0("//*[contains(text(), '", nomes[i], "')]/../../*/*[@class='runtime']")) |> html_text2()
}

cbind(nomes, duracao)

# Tabelas --------

url <- "https://pt.wikipedia.org/wiki/Lista_de_prefeitos_de_Belo_Horizonte"
pagina <- read_html(url)

pagina |> html_table()
tabela <- pagina |> html_element(xpath = "//table[@class='wikitable']") |> html_table(header = TRUE, trim = TRUE)


# Arquivos --------
library("rio")
url <- "https://www.anac.gov.br/acesso-a-informacao/dados-abertos/areas-de-atuacao/voos-e-operacoes-aereas/percentuais-de-atrasos-e-cancelamentos"


pagina <- read_html(url)

links <- pagina |> html_elements(xpath = "//h2/a") |> html_attr('href')

arquivo <- rio::import(link[2])

# Navegação e preechimento de formulários

library("rvest")

url <-"http://www.google.com.br"

s <- session(url)

formulario <- s |> html_form()
formulario <- formulario[[1]]

formulario <- html_form(s)[[1]]

formulario <- formulario |> html_form_set(q = "google acadêmico")

resp <- formulario |> html_form_submit()

p <- read_html(resp)
p |> html_element(xpath = "//h3/div[contains(text(), 'Google Acad')]/../..")

nova_url <- p |> html_element(xpath = "//h3/div[contains(text(), 'Google Acad')]/../..") |> html_attr('href')

s <- s |> session_jump_to(nova_url)
s |> session_history()

formulario <- s |> html_form()
formulario <- formulario[[2]]

formulario <- formulario |> html_form_set(q = "produto interno bruto")

resp <- formulario |> html_form_submit()

p <- read_html(resp)
titulos <- p |> html_elements(xpath = "//h3/a") |> html_text2()
link <- p |> html_elements(xpath = "//h3/a") |> html_attr('href')

trabalhos <- cbind(titulos, link)

s <- s |> session_jump_to(resp$url)
s |> session_history()

formulario <- s |> html_form()
formulario <- formulario[[4]]

formulario <- formulario |> html_form_set(as_ylo = "2015", as_yhi = "2018")

resp <- formulario |> html_form_submit()

p <- read_html(resp)
titulos <- p |> html_elements(xpath = "//h3/a") |> html_text2()

p |> html_elements(xpath = "//a[contains(text(), '2')]/span/..") |> html_attr('href')
s <- s |> session_follow_link(xpath =  "//a[contains(text(), '2')]/span/..")
s |> session_history()

p <- read_html(s)
titulos <- p |> html_elements(xpath = "//h3/a") |> html_text2()

url <- "https://www.google.com/flights?hl=pt-BR"
s <- session(url)
p <- read_html(s)
p |> html_elements(xpath = "//a") |> html_text2()

# Exercício ---------

library(rvest)

url <- "http://fjp.mg.gov.br/"
s <- session(url)

p <- read_html(s)
p |> html_elements(xpath = "//span[contains(text(), 'Biblioteca')]/..")
s <- s |> session_follow_link(xpath = "//span[contains(text(), 'Biblioteca')]/..")

p <- read_html(s)
p |> html_elements(xpath = "//figcaption[contains(text(), 'Institucional')]/../a")
s <- s |> session_follow_link(xpath = "//figcaption[contains(text(), 'Institucional')]/../a")

f <- s |> html_form()
f <- f[[2]]

f <- f |> html_form_set(query = "produto interno bruto")
resp <- f |> html_form_submit()

p <- read_html(resp)
p |> html_elements(xpath = "//h3[contains(text(), 'Conjunto')]/../table")
tabela <- p |> html_elements(xpath = "//h3[contains(text(), 'Conjunto')]/../table") |> html_table()

