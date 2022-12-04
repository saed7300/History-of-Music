library(cluster)
library(tidyverse)
library(dbscan)
library(dplyr)
library(dendextend)


feature_data <- read.csv("https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Features/clean_feature_data.csv")
features_select <-feature_data%>%
  select(Song.Title, Decade, danceability, energy, loudness, speechiness,
         acousticness,	instrumentalness,	liveness,	valence,	tempo, duration)

#decades
sixties <- features_select%>%
  subset(Decade == "60s")
seventies <- features_select%>%
  subset(Decade == "70s")
eighties <- features_select%>%
  subset(Decade == "80s")
ninties <- features_select%>%
  subset(Decade == "90s")
twothousand <- features_select%>%
  subset(Decade == "2000s")
twoten <- features_select%>%
  subset(Decade == "2010s")
twotwo <- features_select%>%
  subset(Decade == "2020s")


decade_list <- list(sixties, seventies, eighties, ninties, twothousand, twoten, twotwo)
decade_names <- list("60s", "70s", "80s", "90s", "2000s", "2010s", "2020s")
decade_names[1]
title <- 1
for (decade in decade_list){
  print(decade)
  features_select <- decade%>%
    select(-c(Decade))
  #print(features_select)
  features_select <-sample_n(features_select, size = 95, replace = FALSE)
  features_select <- features_select[!duplicated(features_select$Song.Title),]
  rownames(features_select) <- features_select$Song.Title
  features_select<-features_select%>%
    select(-c(Song.Title))
  hc <- features_select[1:50,]%>%
    scale %>% 
    dist %>% hclust %>% as.dendrogram
  print(hc %>% set("branches_k_col", value = c("green", "blue", "orange", "pink", "red"), k=5) %>% 
    plot(main = paste(decade_names[title], " Playlist")))
  title<- title+1
}
