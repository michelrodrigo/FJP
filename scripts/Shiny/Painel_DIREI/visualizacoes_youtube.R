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



output$grafico_visualizacoes <- renderHighchart({
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
  
  
  
  h
  
})
