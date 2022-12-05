library(dplyr)
library(tidyverse)
library(readxl)
library(rpart) 
library(rattle)
library(rpart.plot)
rm(list = ls())
feature_data <- read.csv("https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Features/clean_feature_data.csv")

decade_included<- feature_data%>%
  select(Genre, Decade, danceability, loudness,
         acousticness,	instrumentalness,	liveness,	valence,	tempo, key_character)
genre_ident <- feature_data%>%
  select(Genre, danceability, loudness,
         acousticness,	instrumentalness,	liveness,	valence,	tempo, key_character)

print(str(genre_ident))

ggplot(genre_ident, aes(x=Genre))+ geom_bar()
table(genre_ident$Genre)

#down sampling the data
down_sample<-genre_ident%>%
  filter(Genre %in% c('Rock', 'Pop', 'R&B/Soul'))
table(down_sample$Genre)

#taking a smaller sample to even out the genres more
rock_len <- which(down_sample$Genre=='Rock')
pop_len <- which(down_sample$Genre=='Pop')
rb_len <- which(down_sample$Genre=='R&B/Soul')

rock_samp <- sample(rock_len,length(rock_len))
pop_samp <- sample(pop_len,length(rock_len))
rb_samp <- sample(rb_len,length(rb_len))

data_down_sample <- down_sample[c(rock_samp, rb_samp, pop_samp),]
check_d<-data_down_sample %>% group_by(Genre) %>% summarize(count=n())
table(check_d)

data_down_sample$Genre <- as.factor(data_down_sample$Genre)
data_down_sample$key_character <- as.factor(data_down_sample$key_character)

print(str(data_down_sample))

#Creating the traing and testing samples
data_size=nrow(data_down_sample)
training_set_size<-floor(data_size*(3/4))
testing_set_sixe<-data_size-training_set_size

set.seed(1234)

train_samp<-sample(nrow(data_down_sample), training_set_size, replace = FALSE)
train_set <- data_down_sample[train_samp,]
table(train_set$Genre)

test_set<-data_down_sample[-train_samp,]
table(test_set$Genre)

test_labels <- test_set$Genre
test_set_nolab <- test_set[,-which(names(test_set)%in%c('Genre'))]

#creating the decision tree model and plot
dt <- rpart(train_set$Genre~.,data=train_set, method='class')
summary(dt)

fancyRpartPlot(dt)

#confusion matrix and accuracy
dt_predict = predict(dt, test_set_nolab, type='class')
predict_table<-table(dt_predict,test_labels)
print(predict_table)
accuracy_Test <- sum(diag(predict_table)) / sum(predict_table)
print(paste('Accuracy for test', accuracy_Test))

#tuning the decision tree
accuracy_tune <- function(fit) {
  predict_unseen <- predict(fit, test_set_nolab, type = 'class')
  table_mat <- table(predict_unseen, test_labels)
  print(table_mat)
  accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
  print(paste('Accuracy for test', accuracy_Test))
}

control <- rpart.control(minsplit = 200,
                         minbucket = round(300/3),
                         maxdepth = 4,
                         cp = 0)
tune_fit <- rpart(Genre~., data=train_set, control=control)
accuracy_tune(tune_fit)

#---------------

#---------------------------
#Important variables
down_sample<-decade_included%>%
  filter(Genre %in% c('Rock', 'Pop', 'R&B/Soul'))
rock_len <- which(down_sample$Genre=='Rock')
pop_len <- which(down_sample$Genre=='Pop')
rb_len <- which(down_sample$Genre=='R&B/Soul')

rock_samp <- sample(rock_len,length(rock_len))
pop_samp <- sample(pop_len,length(rock_len))
rb_samp <- sample(rb_len,length(rb_len))


data_down_sample <- down_sample[c(rock_samp, rb_samp, pop_samp),]
boruta_data<-data_down_sample
boruta_data$Genre <- as.factor(boruta_data$Genre)
boruta_data$key_character <- as.factor(boruta_data$key_character)
boruta_data$Decade <- as.factor(boruta_data$Decade)

library(Boruta)
# Decide if a variable is important or not using Boruta
boruta_output <- Boruta(Genre ~ . , boruta_data, doTrace=0) # perform Boruta search
print(boruta_output)
plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variable Importance") 
boruta_signif <- getSelectedAttributes(boruta_output, withTentative = TRUE)
print(boruta_signif)  

library(randomForest)
library(DALEX)
rf_mod <- randomForest(factor(Genre) ~ ., data = data_down_sample, ntree=100)
rf_mod
explained_rf <- explain(rf_mod, data=data_down_sample, y=data_down_sample$Genre)

varimps = variable_importance(explained_rf, type='raw')
print(varimps)
plot(varimps)


#------Reducing the features
genre_reduced <- feature_data%>%
  select(Genre, Decade, danceability, loudness,
         acousticness,	instrumentalness,	tempo)
down_sample<-genre_reduced%>%
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

data_down_sample$Genre <- as.factor(data_down_sample$Genre)
data_down_sample$key_character <- as.factor(data_down_sample$key_character)

print(str(data_down_sample))

data_size=nrow(data_down_sample)
training_set_size<-floor(data_size*(3/4))
testing_set_sixe<-data_size-training_set_size

set.seed(1234)

train_samp<-sample(nrow(data_down_sample), training_set_size, replace = FALSE)
train_set <- data_down_sample[train_samp,]
table(train_set$Genre)

test_set<-data_down_sample[-train_samp,]
table(test_set$Genre)

test_labels <- test_set$Genre
test_set_nolab <- test_set[,-which(names(test_set)%in%c('Genre'))]

dt <- rpart(train_set$Genre~.,data=train_set, method='class')
summary(dt)

fancyRpartPlot(dt)

dt_predict = predict(dt, test_set_nolab, type='class')
predict_table<-table(dt_predict,test_labels)
print(predict_table)
accuracy_Test <- sum(diag(predict_table)) / sum(predict_table)
print(paste('Accuracy for test', accuracy_Test))


accuracy_tune <- function(fit) {
  predict_unseen <- predict(fit, test_set_nolab, type = 'class')
  table_mat <- table(predict_unseen, test_labels)
  print(table_mat)
  accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
  print(paste('Accuracy for test', accuracy_Test))
}

control <- rpart.control(minsplit = 200,
                         minbucket = round(200/3),
                         maxdepth = 4,
                         cp = 0)
tune_fit <- rpart(Genre~., data=train_set, control=control)
accuracy_tune(tune_fit)

#-----