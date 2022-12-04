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

#Removing all non real measures
cluster_df <- feature_data%>%
  select(-c(mode_char, mode, key_character,Song.Title, Artist, Year, Rank))
cluster_df <- cluster_df%>%
  select(-c(key, time_signature))

# All Data
cluster_df_all<- cluster_df%>%
  select(-c(Decade, Genre))

scaled_df <- scale(cluster_df_all)
str(scaled_df)

# Elbow method
print(fviz_nbclust(x = scaled_df, 
                   FUNcluster = kmeans,
                   method = 'wss',)+
        labs(title = paste("All Decades", "Elbow Graph")
        ))


# Silhouette method
print(fviz_nbclust(scaled_df, 
                   kmeans, 
                   method= "silhouette",)+
        labs(title = paste("All Decades", "Silhoutte Graph"))
)


RNGkind(sample.kind = "Rounding")
set.seed(100)

kmeans_red <- kmeans(x = scaled_df, centers = 2)
print(paste("All Decades", "KMeans Cluster Sizes"))
print(kmeans_red$size)
#print("All Decades centriods")
#print(kmeans_red$centers)

#head(kmeans_red$cluster)
print("Number of times kmeans was itterated")
kmeans_red$iter

print(fviz_cluster(object =kmeans_red,
                   data = cluster_df_all, labelsize = 1)+
        labs(title = paste("All Decades", "Cluster Graph")))


cluster_df_all$cluster <- kmeans_red$cluster

print(ggRadar(
  data=cluster_df_all,
  mapping = aes(colours = cluster)
)+labs(title = paste("All Decades", "Radar Graph")))

#Goodness of fit
print(paste("All Decades", "Goodness of Fit Output"))
print(kmeans_red$withinss)

# bss/tss check 
print("Quality of the Clusters")
print(kmeans_red$betweenss/kmeans_red$totss)




#---------
#Reducing the # of features
features_reduced_inital<-cluster_df%>%
  select(-c(Genre, Decade, speechiness, energy, duration))
scaled_features_pca <- prcomp(features_reduced_inital, center = TRUE, scale = TRUE)
summary(scaled_features_pca)

plot_pca <- plot(scaled_features_pca, type="l")
plot_pca

fviz_pca_var(scaled_features_pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)
#backwards reduction using PCA
features_reduced<-cluster_df%>%
  select(-c(Decade, Genre, speechiness, energy, duration, instrumentalness, liveness, tempo, acousticness))
scaled_features_pca <- prcomp(features_reduced, center = TRUE, scale = TRUE)
summary(scaled_features_pca)
plot_pca <- plot(scaled_features_pca, type="l")
plot_pca

fviz_pca_var(scaled_features_pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)


scaled_reduced <- as.data.frame(-scaled_features_pca$x[,1:3])
cluster_reduced<-features_reduced
cluster_reduced_scaled<-scale(features_reduced)
# Elbow method
print(fviz_nbclust(x = cluster_reduced_scaled, 
                   FUNcluster = kmeans,
                   method = 'wss',)+
        labs(title = paste("All Decades", "Elbow Graph")
        ))


# Silhouette method
print(fviz_nbclust(cluster_reduced_scaled, 
                   kmeans, 
                   method= "silhouette",)+
        labs(title = paste("All Decades", "Silhoutte Graph"))
)


RNGkind(sample.kind = "Rounding")
set.seed(100)

kmeans_red <- kmeans(x = cluster_reduced_scaled, centers = 2)
print(paste("All Decades", "KMeans Output"))
print(kmeans_red$size)

kmeans_red$centers

head(kmeans_red$cluster)

kmeans_red$iter

#Goodness of fit
print(paste("All Decades", "Goodness of Fit Output"))
print(kmeans_red$withinss)

# bss/tss check 
print(kmeans_red$betweenss/kmeans_red$totss)

#graphing the clusters
print(fviz_cluster(object =kmeans_red,
                   data = cluster_reduced, labelsize = 1)+
        labs(title = paste("All Decades", "Cluster Graph")))


cluster_reduced$cluster <- kmeans_red$cluster

print(ggRadar(
  data=cluster_reduced,
  mapping = aes(colours = cluster)
)+labs(title = paste("All Decades", "Radar Graph")))

#---------------------------
#Going through the decades

feature_selections<-cluster_df%>%
  select(-c(speechiness, energy, duration, instrumentalness, liveness, tempo, acousticness))

#decades
sixties <- feature_selections%>%
  subset(Decade == "60s")
seventies <- feature_selections%>%
  subset(Decade == "70s")
eighties <- feature_selections%>%
  subset(Decade == "80s")
ninties <- feature_selections%>%
  subset(Decade == "90s")
twothousand <- feature_selections%>%
  subset(Decade == "2000s")
twoten <- feature_selections%>%
  subset(Decade == "2010s")
twotwo <- feature_selections%>%
  subset(Decade == "2020s")

decade_list <- list(sixties, seventies, eighties, ninties, twothousand,twoten, twotwo)
decade_names <- list("60s", "70s", "80s", "90s", "2000s", "2010s", "2020s")

title <- 1
for (decade in decade_list){
  
  cluster_df_1 <- decade%>%
    select(-c(Decade, Genre))
  #str(cluster_df_1)
  
  scaled_df <- scale(cluster_df_1)
  str(scaled_df)
  
  # Elbow method
  print(fviz_nbclust(x = scaled_df, 
                     FUNcluster = kmeans,
                     method = 'wss',)+
          labs(title = paste(decade_names[title], "Elbow Graph")
          ))
  
  
  # Silhouette method
  print(fviz_nbclust(scaled_df, 
                     kmeans, 
                     method= "silhouette",)+
          labs(title = paste(decade_names[title], "Silhoutte Graph"))
  )
  title <- title + 1
  
}

title <- 1


for (decade in decade_list){
  if (title!= 4){
    k=2
  } else{
    k=3
  }
  cluster_df_1 <- decade%>%
    select(-c(Decade, Genre))
  #str(cluster_df_1)
  
  scaled_df <- scale(cluster_df_1)
  str(scaled_df)
  RNGkind(sample.kind = "Rounding")
  set.seed(100)
  
  kmeans_red <- kmeans(x = scaled_df, centers = k)
  print(paste(decade_names[title], "KMeans Output"))
  print(kmeans_red$size)
  
  kmeans_red$centers
  
  head(kmeans_red$cluster)
  
  kmeans_red$iter
  
  #Goodness of fit
  print(paste(decade_names[title], "Goodness of Fit Output"))
  print(kmeans_red$withinss)
  
  # bss/tss check 
  print(kmeans_red$betweenss/kmeans_red$totss)
  
  print(fviz_cluster(object =kmeans_red,
                     data = cluster_df_1, labelsize = 1)+
          labs(title = paste(decade_names[title], "Cluster Graph")))
  
  
  cluster_df_1$cluster <- kmeans_red$cluster
  
  print(ggRadar(
    data=cluster_df_1,
    mapping = aes(colours = cluster)
  )+labs(title = paste(decade_names[title], "Radar Graph")))
  title <- title+1
}


#Genre Happiness
feature_pca_short<- features_red%>%
  select(-c(speechiness, energy, duration, instrumentalness, liveness, tempo, acousticness))

cluster_df_genre <- cluster_df%>%
  select(-c(Decade))
genre_names <- cluster_df_genre[1]
count(genre_names, Genre, sort = TRUE)
ggplot(genre_names, aes(Genre))+geom_bar()
features_use<-cluster_df_genre[-1]
features_use<- features_use%>%
  select(-c(speechiness, energy, duration, instrumentalness, liveness, tempo, acousticness))

scaled_features <- scale(features_use)
str(scaled_features)

RNGkind(sample.kind = "Rounding")
set.seed(100)
kmeans_features <- kmeans(x = scaled_features, centers = 2)

print(fviz_cluster(object =kmeans_features,
                   data = features_use, labelsize = 1)+
        labs(title = paste("Genre Attempt ", "Cluster Graph")))

features_use$cluster <- kmeans_features$cluster

print(ggRadar(
  data=features_use,
  mapping = aes(colours = cluster)
)+labs(title = paste("All Decades", "Radar Graph")))

kmeans_features$cluster
genre_names$cluster <- kmeans_features$cluster
genre_names[genre_names == 1] <- "More Negative"
genre_names[genre_names == 2] <- "More Happy"
ggplot(genre_names, aes(Genre))+geom_bar(aes(fill=cluster))+labs(title = paste("Genre Happiness ", "Graph"))


# 
# #----------------
# #Trying to cluster the genres
# 
# cluster_df_genre <- cluster_df%>%
#   select(-c(Decade))
# genre_names <- cluster_df_genre[1]
# count(genre_names, Genre, sort = TRUE)
# ggplot(genre_names, aes(Genre))+geom_bar()
# features_use<-cluster_df_genre[-1]
# 
# scaled_features <- scale(features_use)
# str(scaled_features)
# 
# RNGkind(sample.kind = "Rounding")
# set.seed(100)
# kmeans_features <- kmeans(x = scaled_features, centers = 6)
# 
# print(fviz_cluster(object =kmeans_features,
#                    data = features_use, labelsize = 1)+
#         labs(title = paste("Genre Attempt ", "Cluster Graph")))
# 
# kmeans_features$cluster
# genre_names$cluster <- kmeans_features$cluster
# genre_names[genre_names == 1] <- "c1"
# genre_names[genre_names == 2] <- "c2"
# genre_names[genre_names == 3] <- "c3"
# genre_names[genre_names == 4] <- "c4"
# genre_names[genre_names == 4] <- "c5"
# genre_names[genre_names == 4] <- "c6"
# genre_names[genre_names == 4] <- "c7"
# ggplot(genre_names, aes(Genre))+geom_bar(aes(fill=cluster))

# 
# #-------
# #Reducing the genre count
# rock_len <- which(cluster_df_genre$Genre=='Pop')
# pop_len <- which(cluster_df_genre$Genre=='Rock')
# rb_len <- which(cluster_df_genre$Genre=='R&B/Soul')
# hh_len <- which(cluster_df_genre$Genre=='Hip-Hop/Rap')
# at_len <- which(cluster_df_genre$Genre=='Alternative')
# cn_len <- which(cluster_df_genre$Genre=='Country')
# 
# 
# length(rock_len)
# length(pop_len)
# length(rb_len)
# length(hh_len)
# length(at_len)
# length(cn_len)
# 
# rock_samp <- sample(rock_len,length(hh_len))
# pop_samp <- sample(pop_len,length(hh_len))
# rb_samp <- sample(rb_len,length(hh_len))
# at_samp <- sample(at_len,length(at_len))
# cn_samp <- sample(cn_len,length(cn_len))
# hh_samp <- sample(hh_len,length(hh_len))
# 
# features_red <- cluster_df_genre[c(rock_samp, rb_samp, pop_samp, cn_samp, at_samp, hh_samp),]
# merge_count3<-features_red %>% group_by(Genre) %>% summarize(count=n())
# table(merge_count3)
# ggplot(features_red, aes(Genre))+geom_bar()
# 
# genre_names <- features_red[1]
# count(genre_names, Genre, sort = TRUE)
# ggplot(genre_names, aes(Genre))+geom_bar()
# features_use<-features_red[-1]
# 
# scaled_features <- scale(features_use)
# str(scaled_features)
# 
# RNGkind(sample.kind = "Rounding")
# set.seed(100)
# kmeans_features <- kmeans(x = scaled_features, centers = 6)
# 
# print(fviz_cluster(object =kmeans_features,
#                    data = features_use, labelsize = 1)+
#         labs(title = paste("Genre Attempt ", "Cluster Graph")))
# 
# kmeans_features$cluster
# genre_names$cluster <- kmeans_features$cluster
# genre_names[genre_names == 1] <- "c1"
# genre_names[genre_names == 2] <- "c2"
# genre_names[genre_names == 3] <- "c3"
# genre_names[genre_names == 4] <- "c4"
# genre_names[genre_names == 4] <- "c5"
# genre_names[genre_names == 4] <- "c6"
# genre_names[genre_names == 4] <- "c7"
# ggplot(genre_names, aes(Genre))+geom_bar(aes(fill=cluster))
# 
# feature_pca_short<- features_red%>%
#   select(-c(speechiness, energy, duration, instrumentalness, liveness, tempo, acousticness))
# 
# genre_names <- feature_pca_short[1]
# count(genre_names, Genre, sort = TRUE)
# ggplot(genre_names, aes(Genre))+geom_bar()
# features_use<-feature_pca_short[-1]
# 
# scaled_features <- scale(features_use)
# str(scaled_features)
# 
# RNGkind(sample.kind = "Rounding")
# set.seed(100)
# kmeans_features <- kmeans(x = scaled_features, centers = 6)
# 
# print(fviz_cluster(object =kmeans_features,
#                    data = features_use, labelsize = 1)+
#         labs(title = paste("Genre Attempt ", "Cluster Graph")))
# 
# kmeans_features$cluster
# genre_names$cluster <- kmeans_features$cluster
# genre_names[genre_names == 1] <- "c1"
# genre_names[genre_names == 2] <- "c2"
# genre_names[genre_names == 3] <- "c3"
# genre_names[genre_names == 4] <- "c4"
# genre_names[genre_names == 4] <- "c5"
# genre_names[genre_names == 4] <- "c6"
# genre_names[genre_names == 4] <- "c7"
# ggplot(genre_names, aes(Genre))+geom_bar(aes(fill=cluster))

#--------------------



