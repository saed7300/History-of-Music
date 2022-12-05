library(dplyr)
library(tidyverse)
library(psych)
library(e1071)

rm(list = ls())


feature_data <- read.csv("https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Features/clean_feature_data.csv")
decade_included<- feature_data%>%
  select(Genre, Decade, key_character, danceability, loudness,
         acousticness,	instrumentalness,	liveness,	valence,	tempo)

down_sample<-decade_included%>%
  filter(Genre %in% c('Rock', 'Pop', 'R&B/Soul'))
table(down_sample$Genre)

rock_len <- which(down_sample$Genre=='Rock')
pop_len <- which(down_sample$Genre=='Pop')
rb_len <- which(down_sample$Genre=='R&B/Soul')

rock_samp <- sample(rock_len,length(rock_len))
pop_samp <- sample(pop_len,length(rock_len))
rb_samp <- sample(rb_len,length(rb_len))

data_down_sample <- down_sample[c(rock_samp, rb_samp, pop_samp),]
check_d<-data_down_sample %>% group_by(Genre) %>% summarize(count=n())
table(check_d)


categorical_data<- data_down_sample[1:3]
saled_numerical <- as.data.frame(scale(data_down_sample[4:10]))

scaled_data <- cbind(categorical_data, saled_numerical)

scaled_data$Genre <- as.factor(data_down_sample$Genre)
scaled_data$key_character <- as.factor(data_down_sample$key_character)
scaled_data$Decade <- as.factor(data_down_sample$Decade)
#pairs.panels(scaled_data[-12])


data_size=nrow(scaled_data)
training_set_size<-floor(data_size*(3/4))
testing_set_sixe<-data_size-training_set_size

set.seed(1234)

train_samp<-sample(nrow(scaled_data), training_set_size, replace = FALSE)
train_set <- scaled_data[train_samp,]
table(train_set$Genre)

test_set<-scaled_data[-train_samp,]
table(test_set$Genre)

test_labels <- test_set$Genre
test_set_nolab <- test_set[,-which(names(test_set)%in%c('Genre'))]

model_nb = naiveBayes(Genre~., data=train_set)
class(model_nb)
pred_nb = predict(model_nb, test_set_nolab)
pred_nb
table(pred_nb)
table(test_labels)

confusion_mat<-table(test_set$Genre, pred_nb)
confusion_mat
accuracy<-1 - sum(diag(confusion_mat)) / sum(confusion_mat)
accuracy




#------------
#reducing the variables
genre_reduced <- feature_data%>%
  select(Genre, Decade, danceability, loudness,
         acousticness,	instrumentalness,	tempo)

down_sample<-genre_reduced%>%
  filter(Genre %in% c('Rock', 'Pop', 'R&B/Soul'))
table(down_sample$Genre)

down_sample<-genre_ident%>%
  filter(Genre %in% c('Rock', 'Pop', 'R&B/Soul'))
table(down_sample$Genre)

rock_len <- which(down_sample$Genre=='Rock')
pop_len <- which(down_sample$Genre=='Pop')
rb_len <- which(down_sample$Genre=='R&B/Soul')

rock_samp <- sample(rock_len,length(rock_len))
pop_samp <- sample(pop_len,length(rock_len))
rb_samp <- sample(rb_len,length(rb_len))

data_down_sample <- down_sample[c(rock_samp, rb_samp, pop_samp),]
check_d<-data_down_sample %>% group_by(Genre) %>% summarize(count=n())
table(check_d)

categorical_data<- data_down_sample[1:2]
saled_numerical <- as.data.frame(scale(data_down_sample[3:7]))

scaled_data <- cbind(categorical_data, saled_numerical)
scaled_data$Genre <- as.factor(data_down_sample$Genre)
scaled_data$Decade <- as.factor(data_down_sample$Decade)

#pairs.panels(scaled_data[-12])


data_size=nrow(scaled_data)
training_set_size<-floor(data_size*(3/4))
testing_set_sixe<-data_size-training_set_size

set.seed(1234)

train_samp<-sample(nrow(scaled_data), training_set_size, replace = FALSE)
train_set <- scaled_data[train_samp,]
table(train_set$Genre)

test_set<-scaled_data[-train_samp,]
table(test_set$Genre)

test_labels <- test_set$Genre
test_set_nolab <- test_set[,-which(names(test_set)%in%c('Genre'))]

model_nb = naiveBayes(Genre~., data=train_set)
class(model_nb)
pred_nb = predict(model_nb, test_set_nolab)
pred_nb
table(pred_nb)
table(test_labels)

confusion_mat<-table(test_set$Genre, pred_nb)
confusion_mat
accuracy<-1 - sum(diag(confusion_mat)) / sum(confusion_mat)
accuracy


#Decades with these genres
set.seed(1234)

train_samp<-sample(nrow(scaled_data), training_set_size, replace = FALSE)
train_set <- scaled_data[train_samp,]
table(train_set$Decade)

test_set<-scaled_data[-train_samp,]
table(test_set$Decade)

test_labels <- test_set$Decade
test_set_nolab <- test_set[,-which(names(test_set)%in%c('Decade'))]

model_nb = naiveBayes(Decade~., data=train_set)
class(model_nb)
pred_nb = predict(model_nb, test_set_nolab)
pred_nb
table(pred_nb)
table(test_labels)

confusion_mat<-table(test_set$Decade, pred_nb)
confusion_mat
accuracy<-1 - sum(diag(confusion_mat)) / sum(confusion_mat)
accuracy

#------------------
#Sorting the decades with all genres
decade_reduced <- feature_data%>%
  select(Genre, Decade, danceability, loudness,
         acousticness,	instrumentalness,	tempo)
down_sample<-decade_reduced%>%
  filter(Decade != '2022s')
table(down_sample$Decade)

categorical_data<- data_down_sample[1:2]
saled_numerical <- as.data.frame(scale(data_down_sample[3:7]))

scaled_data <- cbind(categorical_data, saled_numerical)
scaled_data$Genre <- as.factor(data_down_sample$Genre)
scaled_data$Decade <- as.factor(data_down_sample$Decade)

#pairs.panels(scaled_data[-12])


data_size=nrow(scaled_data)
training_set_size<-floor(data_size*(3/4))
testing_set_sixe<-data_size-training_set_size

set.seed(1234)

train_samp<-sample(nrow(scaled_data), training_set_size, replace = FALSE)
train_set <- scaled_data[train_samp,]
table(train_set$Decade)

test_set<-scaled_data[-train_samp,]
table(test_set$Decade)

test_labels <- test_set$Decade
test_set_nolab <- test_set[,-which(names(test_set)%in%c('Decade'))]

model_nb = naiveBayes(Decade~., data=train_set)
class(model_nb)
pred_nb = predict(model_nb, test_set_nolab)
pred_nb
table(pred_nb)
table(test_labels)

confusion_mat<-table(test_set$Decade, pred_nb)
confusion_mat
accuracy<-1 - sum(diag(confusion_mat)) / sum(confusion_mat)
accuracy
