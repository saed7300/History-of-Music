library(cluster)
library(tidyverse)
library(fpc)
library(factoextra)
library(dbscan)
library(dplyr)
library(GGally)
library(inspectdf)
library(ggiraphExtra)

feature_data <- read.csv("https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Features/clean_feature_data.csv")
features_select <-feature_data%>%
  select(Genre, danceability, energy, loudness, speechiness,
         acousticness,	instrumentalness,	liveness,	valence,	tempo, duration)

genre_names <- features_select[1]
count(genre_names, Genre, sort = TRUE)
ggplot(genre_names, aes(Genre))+geom_bar()
features_use<-features_select[-1]
features_use_reduced <-features_use%>%
  select(danceability, loudness, valence)

kNNdistplot(features_use_reduced, k=3)
set.seed(123)
Dbscan_cl <- fpc::dbscan(features_use_reduced, eps=.45, MinPts =50)
Dbscan_cl
plot(features_use_reduced, col=Dbscan_cl$cluster+1, main="DBSCAN")

set.seed(123)
km.res <- kmeans(features_use_reduced, 7, nstart = 25)
fviz_cluster(km.res, features_use_reduced, geom = "point",
             ellipse= FALSE, show.clust.cent = FALSE,
             palette = "jco", ggtheme = theme_classic())
genre_names$cluster <- km.res$cluster

genre_names[genre_names == 1] <- "c1"
genre_names[genre_names == 2] <- "c2"
genre_names[genre_names == 3] <- "c3"
genre_names[genre_names == 4] <- "c4"
genre_names[genre_names == 5] <- "c5"
genre_names[genre_names == 6] <- "c6"
genre_names[genre_names == 7] <- "c7"
ggplot(genre_names, aes(Genre))+geom_bar(aes(fill=cluster))