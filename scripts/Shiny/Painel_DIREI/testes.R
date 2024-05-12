key <- "AIzaSyD0YHD_y_dXJOCwAyORD4fmyssYrfo7l44"

channel_id <- "UCNUzB0qvhYSRSNu_M6R6FSA"  # CS Dojo Channel ID
user_id <- "numberphile"  # Numberphile Username
base <- "https://www.googleapis.com/youtube/v3/"

required_packages <- c("httr", "jsonlite", "here", "dplyr" )
for(i in required_packages) {
  if(!require(i, character.only = T)) {
    #  if package is not existing, install then load the package
    install.packages(i, dependencies = T, repos = "http://cran.us.r-project.org")
    # install.packages(i, dependencies = T, repos = "https://cran.stat.upd.edu.ph/")
    require(i, character.only = T)
  }
}

# Construct the API call
api_params <- 
  paste(paste0("key=", key), 
        paste0("id=", channel_id), 
        "part=snippet,contentDetails,statistics",
        sep = "&")
api_call <- paste0(base, "channels", "?", api_params)
api_result <- GET(api_call)
json_result <- content(api_result, "text", encoding="UTF-8")

# Process the raw data into a data frame
channel.json <- fromJSON(json_result, flatten = T)
channel.df <- as.data.frame(channel.json)

playlist_id <- channel.df$items.contentDetails.relatedPlaylists.uploads

# temporary variables
nextPageToken <- ""
upload.df <- NULL
pageInfo <- NULL

# Loop through the playlist while there is still a next page
while (!is.null(nextPageToken)) {
  # Construct the API call
  api_params <- 
    paste(paste0("key=", key), 
          paste0("playlistId=", playlist_id), 
          "part=snippet,contentDetails,status",
          "maxResults=50",
          sep = "&")
  
  # Add the page token for page 2 onwards
  if (nextPageToken != "") {
    api_params <- paste0(api_params,
                         "&pageToken=",nextPageToken)
  }
  
  api_call <- paste0(base, "playlistItems", "?", api_params)
  api_result <- GET(api_call)
  json_result <- content(api_result, "text", encoding="UTF-8")
  upload.json <- fromJSON(json_result, flatten = T)
  
  nextPageToken <- upload.json$nextPageToken
  pageInfo <- upload.json$pageInfo
  
  curr.df <- as.data.frame(upload.json$items)
  if (is.null(upload.df)) {
    upload.df <- curr.df
  } else {
    upload.df <- bind_rows(upload.df, curr.df)
  }
}

video.df<- NULL
# Loop through all uploaded videos
for (i in 1:nrow(upload.df)) {
  # Construct the API call
  video_id <- upload.df$contentDetails.videoId[i]
  api_params <- 
    paste(paste0("key=", key), 
          paste0("id=", video_id), 
          "part=id,statistics,contentDetails",
          sep = "&")
  
  api_call <- paste0(base, "videos", "?", api_params)
  api_result <- GET(api_call)
  json_result <- content(api_result, "text", encoding="UTF-8")
  video.json <- fromJSON(json_result, flatten = T)
  
  curr.df <- as.data.frame(video.json$items)
  
  if (is.null(video.df)) {
    video.df <- curr.df
  } else {
    video.df <- bind_rows(video.df, curr.df)
  }
}  

# Combine all video data frames
video.df$contentDetails.videoId <- video.df$id
video_final.df <- merge(x = upload.df, 
                        y = video.df,
                        by = "contentDetails.videoId")

webinarios <- c("y3rUIsw9Jag",
                "ksDZCddo7b8")

nomes_videos <- c("Patos de Minas",
                  "Uberlândia")

visualizacoes <- video.df |> select(statistics.viewCount, id, ) |> subset( video.df$id %in% webinarios)

dados <- data.frame(x=c(1:length(nomes_videos)),
                    y=visualizacoes$statistics.viewCount)

h <- highchart() |>
 
  hc_chart(type = "column") |>
  hc_yAxis(title = list(text = "Valor do indicador ")) |>
  hc_title(text = "Visualizações")

for (k in 1:length(nomes_videos)) {
  dados <- data.frame(x= k ,
                     y= as.numeric(visualizacoes$statistics.viewCount[k]))
  print(dados)
  h <- h |> 
    hc_add_series(data = dados, name = nomes_videos[k])
}
  


pag_fjp <- read_html("http://fjp.mg.gov.br/produto-interno-bruto-pib-de-minas-gerais/")
esgopag_fjp |> html_elements(xpath = "//a[contains(text(), 'Base')]/../../../*/div[@id='elementor-tab-content-1429']/*/li[2]/a") 

<div id="elementor-tab-content-1429" class="elementor-tab-content elementor-clearfix elementor-active" data-tab="9" role="tabpanel" aria-labelledby="elementor-tab-title-1429" style="display: block;"><ul><li><a href="http://fjp.mg.gov.br/wp-content/uploads/2022/01/18.03_Anexo-Estatistico-PIBmg-2021-4.xlsx">Anexo estatístico – PIB trimestral – 4º trimestre de 2021 (XLSX, 319 KB)</a></li><li><a href="http://fjp.mg.gov.br/wp-content/uploads/2021/10/02.12_Anexo-estatistico-PIB-MG-anual-2010-2019.xlsx">Anexo estatístico – PIB MG anual – 2010-2019 (XLSX, 126 KB)</a></li><li><a href="http://fjp.mg.gov.br/wp-content/uploads/2021/10/02.12_Anexo-estatistico-PIB-MG-anual-2002-2019-Retropolacao.xlsx">Anexo estatístico – PIB MG anual – 2002-2019 (retropolação)</a> (XLSX, 118 KB)</li><li><a href="https://docs.google.com/spreadsheets/d/17Xt-Sq7cy_h7LuSetdMlkEp9OifuAIim/edit?usp=sharing&amp;ouid=104372843943715905267&amp;rtpof=true&amp;sd=true">Anexo estatístico – PIB municipal – 2010-2019 (Google Drive)</a></li><li><a href="http://fjp.mg.gov.br/wp-content/uploads/2019/12/ANEXO-ESTATÍSTICO-2002-2009.xlsx">Anexo estatístico – PIB municipal – 2002-2009 (XLSX, 1 MB)</a></li></ul></div>
  //*[@id="elementor-tab-content-1429"]/ul/li[2]/a

library(rsconnect)
rsconnect::deployApp('H:/FJP/scripts/Shiny/PIB/PIB_MG/')
  
  
https://www.googleapis.com/youtube/v3/channels?key=AIzaSyD0YHD_y_dXJOCwAyORD4fmyssYrfo7l44&id=UCxX9wt5FWQUAAz4UrysqK9A&part=snippet,contentDetails,statistics