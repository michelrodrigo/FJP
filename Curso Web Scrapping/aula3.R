library(rvest)

url <-"http://www.google.com.br"
s <- session(url)

formulario <- s |> html_form()
formulario <- formulario[[1]]

formulario <- formulario |> html_form_set(q="google academico")

resp <- formulario |> html_form_submit()

s |> session_submit(formulario)

p <- read_html(resp)
p |> html_element(xpath = "//div[contains(text(), 'Google Acad')]/../..")


nova_url <- p |> html_element(xpath = "//div[contains(text(), 'Google Acad')]/../..") |> html_attr('href')
s <- s |> session_jump_to(nova_url)


s |> session_history()

#p <- read_html(s$url)
#p |> html_element(xpath = "//*[contains(text(), 'Pesquisa')]/../a")
#s |> session_follow_link(xpath = "//*[contains(text(), 'Pesquisa')]/../a")

formulario <- s |> html_form()
formulario <- formulario[[2]]

formulario <- formulario |> html_form_set(q="produto interno bruto")

resp <- formulario |> html_form_submit()

p <- read_html(resp)

p |> html_elements(xpath = "//h3/a") |> html_text2()

s <- s |> session_jump_to(resp$url)

formulario <- s |> html_form()
formulario <- formulario[[4]]

formulario <- formulario |> html_form_set(as_ylo ="2015", as_yhi = "2015")

resp <- formulario |> html_form_submit()

p <- read_html(resp)

p |> html_elements(xpath = "//h3/a") |> html_text2()
#p |> html_elements(xpath = "//*[contains(text(), 'incluir cit')]/..") 
#s <- s |> session_follow_link(xpath = "//*[contains(text(), 'incluir cit')]/..")

#p <- read_html(s$url)

#p |> html_elements(xpath = "//h3/a") |> html_text2()

p |> html_elements(xpath = "//a[contains(text(), '2')]/span[@class= 'gs_ico gs_ico_nav_page']") 

s <- s |> session_follow_link(xpath = "//a[contains(text(), '2')]/span[@class= 'gs_ico gs_ico_nav_page']/..")

p <- read_html(s$url)

p |> html_elements(xpath = "//h3/a") |> html_text2()

#s <- s %>% session_follow_link(xpath = "//span[contains(text(), 'Biblioteca')]/..")
#s <- s %>% session_follow_link(xpath = "//figcaption[contains(text(), 'Biblioteca Digital')]/../a")

url <-"http://fjp.mg.gov.br/"
s <- session(url)

s <- s %>% session_follow_link(xpath = "//span[contains(text(), 'Biblioteca')]/..")
s <- s %>% session_follow_link(xpath = "//figcaption[contains(text(), 'Biblioteca Digital')]/../a")

formulario <- s |> html_form()
formulario <- formulario[[1]]

formulario <- formulario |> html_form_set(busca="pib")
#resp <- s |> session_follow_link(xpath = "//a[contains(text(), 'Pesquisar')]")

#p <- s |> read_html()
#p |> html_elements(xpath= "//*[@onclick='formSubmit();']")

resp <- formulario |> html_form_submit("consulta")
#pagina <- read_html(resp)


url <- "http://repositorio.fjp.mg.gov.br/"

s <- session(url)

s |> html_form()

formulario <- s|> html_form()
formulario <- formulario[[2]]
formulario <- formulario |> html_form_set(query = "produto interno bruto") 
resp <- formulario |> html_form_submit()

p <- read_html(resp$url)
s <- s |> session_jump_to(resp$url)

t <- p |> html_table()

p |> html_elements(xpath = "//p/a[contains(text(), '2')]")
s <- s |> session_follow_link(xpath = "//p/a[contains(text(), '2')]")

p <- read_html(s$url)
p |> html_table()
p |> html_elements(xpath = "//select[@name = 'rpp']/option[contains(text(), '100')]")
s |> session
