

library("xml2")
library("rvest")

url <- "https://www.imdb.com/search/title/?count=10&release_date=2021,2021&title_type=feature"

pagina <- read_html(url)


pagina %>% html_elements(xpath = "//h3/span[1]") %>% html_text2()
pagina %>% html_elements(xpath = "//h3/span[@class = 'lister-item-index unbold text-primary']") %>% html_text2()

rank <- as.numeric(pagina %>% html_elements(xpath = "//h3/span[@class = 'lister-item-index unbold text-primary']") %>% html_text2())

nomes <- pagina %>% html_elements(xpath = "//h3/a") %>% html_text2()

anos <- pagina %>% html_elements(xpath = "//h3/span[2]") %>% html_text2()
anos <- as.numeric(unlist(regmatches(anos, gregexpr("[[:digit:]]+", anos))))


generos <- pagina %>% html_elements(xpath = "//*[@class = 'genre']") %>% html_text2()
generos <- strsplit(generos, ", ")

dura_filme <- pagina %>% html_elements(xpath = "//*[@class = 'runtime']") %>% html_text2()
dura_filme <- as.numeric(unlist(regmatches(dura_filme, gregexpr("[[:digit:]]+", dura_filme))))

pagina %>% html_elements(xpath = "//a[contains(text(), 'Encanto')]/../../*/*[@class = 'runtime']") %>% html_text2()


links <- pagina %>% html_elements(xpath = "//h3/a") %>% html_attr('href')

filmes <- cbind(rank, nomes, anos, dura_filme, generos, links)

#-----

url <- "https://www.imdb.com/search/title/?count=20&title_type=feature&release_date=2015-12-31,2021-01-01&sort=user_rating,desc"

pagina <- read_html(url)

pagina %>% html_elements(xpath = "//*[@class = 'runtime']") %>% html_text2()

nomes <- pagina %>% html_elements(xpath = "//h3/a") %>% html_text2()

duracao <- rep(NA, length(nomes))
for(nome in c(1: length(nomes))){
   duracao[nome] <- pagina %>% html_element(xpath = paste0("//a[contains(text(),'", nomes[nome], "')]/../../*/*[@class = 'runtime']")) %>% html_text2()
}

nome <- 1
duracao[nome] <- pagina %>% html_elements(xpath = paste0("//a[contains(text(),'", nomes[nome], "')]/../../*/*[@class = 'runtime']")) %>% html_text2()

duracao <- rep(NA, length(nomes))
for(i in c(1:length(nomes))){
  duracao[i] <- pagina |> html_element(xpath = paste0("//h3/a[contains(text(),'", nomes[i],"')]/../../*/*[@class='runtime']")) |> html_text2()
}

url <-"http://fjp.mg.gov.br/"
s <- session(url)

s <- s %>% session_follow_link(xpath = "//span[contains(text(), 'Biblioteca')]/..")
s <- s %>% session_follow_link(xpath = "//figcaption[contains(text(), 'Biblioteca Digital')]/../a")

formulario <- s |> html_form()
formulario <- formulario[[1]]

formulario <- formulario |> html_form_set(busca="pib")
resp <- s |> session_follow_link(xpath = "//a[contains(text(), 'Pesquisar')]")

#p <- s |> read_html()
#p |> html_elements(xpath= "//*[@onclick='formSubmit();']")

resp <- formulario |> html_form_submit()
#pagina <- read_html(resp)



https://stackoverflow.com/questions/52009411/submit-post-form-when-rvest-doesnt-recognize-submit-button
https://localcoder.org/how-to-submit-login-form-in-rvest-package-w-o-button-argument


library(xml2)
h <- as_list(read_html("http://www.bibliotecadigital.mg.gov.br/apresentacao/apresentacao.php"))
h$html$body$div[3]


/html/body/div[3]/div[2]/form/p[2]/a

write_html(as_xml_document(h$html), "outfile.html", 
           options=c("format","no_declaration"))