library(dplyr)
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(psych)
rm(list = ls())

#Import the full feature data set from GitHub


data_df <- read.csv("https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Features/full_genre_features.csv")

#Getting rid of unnecessary columns
#These columns serve no purpose other than an id type of value which isnt needed
data_df<- data_df%>%
  select(-c(type, id, uri, track_href, analysis_url))

#chang duration to minutes to make it more understandable
data_df$duration <- data_df$duration_ms/60000

#drop ms duration
data_df<- data_df%>%
  select(-c(duration_ms))

# Key can be treated as a qualitative value since it is linked to a specic key
#Note we will use the sharps for any sharp/flat notes
#E sharp and F are the same
#B sharp is the same as C
key_matches = data.frame(key = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
                         key_character = c('C/B#', 'C#/Db', 'D', 'D#/Eb', 'E',
                                           'F/E#', 'F#/Gb', 'G', 'G#/Ab', 'A',
                                           'A#/Bb', 'B'))

data_df <- merge(data_df, key_matches, by='key')
 
mode_match = data.frame(mode = c(0,1),
                        mode_char = c('minor', 'major'))
data_df <- merge(data_df, mode_match, by='mode')

data_df_mode<- data_df%>%
  group_by(Decade, mode_char)%>%
  tally()
data_df_mode<-data_df_mode%>%
  rename('n_mode'='n')
data_df <- merge(data_df, data_df_mode, by=c('Decade', 'mode_char'))

#head(data_df, 1)

#Feature Vis

decade_order <- c("60s", "70s", "80s", "90s", "2000s", "2010s", "2020s")

decade_danceabilaty <- (ggplot(data_df,
                              aes(x= factor(Decade, decade_order),
                                  y=danceability, fill=Decade))
                        + stat_boxplot(geom = "errorbar", width=.25) 
                        + geom_boxplot() + xlab('Decade') 
                        + ylab('Danceabilaty Scale') + ggtitle('Danceabilaty Through the Decades')
                        )

decade_energy <- (ggplot(data_df,
                               aes(x= factor(Decade, decade_order),
                                   y=energy, fill=Decade))
                        + stat_boxplot(geom = "errorbar", width=.25) 
                        + geom_boxplot() + xlab('Decade') 
                  + ylab('Energy Scale') + ggtitle('Energy Through the Decades')
)

decade_key_char <- (ggplot(data_df,
                           aes(x= factor(Decade, decade_order),
                               y=key_character, fill=key_character)) + 
                      geom_bar(stat='identity')+ xlab('Decade') 
                    + ylab('Song Key') + ggtitle('Song Keys Through the Decades')
)

decade_loudness <- (ggplot(data_df,
                         aes(x= factor(Decade, decade_order),
                             y=loudness, fill=Decade))
                  + stat_boxplot(geom = "errorbar", width=.25) 
                  + geom_boxplot() + xlab('Decade') 
                  + ylab('Loudness Scale (dB)') + ggtitle('Loudness Through the Decades')
)


decade_speechiness <- (ggplot(data_df,
                         aes(x= factor(Decade, decade_order),
                             y=speechiness, fill=Decade))
                  + stat_boxplot(geom = "errorbar", width=.25) 
                  + geom_boxplot() + xlab('Decade') 
                  + ylab('Amount of Speech in Song') + ggtitle('Speechiness Through the Decades')
)

decade_acousticness <- (ggplot(data_df,
                         aes(x= factor(Decade, decade_order),
                             y=acousticness, fill=Decade))
                  + stat_boxplot(geom = "errorbar", width=.25) 
                  + geom_boxplot() + xlab('Decade') 
                  + ylab('Acoustic Scale') + ggtitle('Acousticness Through the Decades')
)

decade_instrumentalness<- (ggplot(data_df,
                               aes(x= factor(Decade, decade_order),
                                   y=instrumentalness, fill=Decade))
                        + stat_boxplot(geom = "errorbar", width=.25) 
                        + geom_boxplot()+xlab('Decade') 
                        + ylab('Vocal Detection') + ggtitle('Instrumentalness Through the Decades')
)

decade_liveness <- (ggplot(data_df,
                                  aes(x= factor(Decade, decade_order),
                                      y=liveness, fill=Decade))
                           + stat_boxplot(geom = "errorbar", width=.25) 
                           + geom_boxplot() + xlab('Decade') 
                    + ylab('Likilhood of Live Audience') + ggtitle('Liveness Through the Decades')
)

decade_valence<- (ggplot(data_df,
                                  aes(x= factor(Decade, decade_order),
                                      y=valence, fill=Decade))
                           + stat_boxplot(geom = "errorbar", width=.25) 
                           + geom_boxplot() + xlab('Decade') 
                  + ylab('Musical Positiveness Scale') + ggtitle('Valence Through the Decades')
)

decade_tempo<- (ggplot(data_df,
                                  aes(x= factor(Decade, decade_order),
                                      y=tempo, fill=Decade))
                           + stat_boxplot(geom = "errorbar", width=.25) 
                           + geom_boxplot() + xlab('Decade') 
                + ylab('Speed of Song (BPM)') + ggtitle('Tempo Through the Decades')
)

decade_duration<- (ggplot(data_df,
                                  aes(x= factor(Decade, decade_order),
                                      y=duration, fill=Decade))
                           + stat_boxplot(geom = "errorbar", width=.25) 
                           + geom_boxplot() + xlab('Decade') 
                      + ylab('Length of Song (minutes)') + ggtitle('Duration Through the Decades')
)

decade_time_signature<- (ggplot(data_df,
                             aes(x= factor(Decade, decade_order),
                                 y=time_signature, fill=Decade))
                      + stat_boxplot(geom = "errorbar", width=.25) 
                      + geom_boxplot() + xlab('Decade') 
                      + ylab('Measure of Songs') + ggtitle('Time Signature Through the Decades')
)

mean_mode<-data_df%>%
  group_by('Decade')%>%
  mutate(mean_mode = max(n_mode)+min(n_mode))

decade_mode <- (ggplot(mean_mode,
                       aes(x= factor(Decade, decade_order), y=mean_mode,
                           fill=mode_char))
                + geom_bar(stat = "identity")+ 
                  xlab('Decade') + ylab('Mode of Songs') + 
                  ggtitle('Time Signature Through the Decades')+
                  theme(axis.text.y=element_blank(),
                        axis.ticks.y=element_blank() 
                  )
                )
grid.arrange(decade_danceabilaty, decade_energy, decade_speechiness,
             decade_instrumentalness, decade_duration, decade_valence,
             decade_liveness, ncol=3)

grid.arrange(decade_acousticness,decade_tempo, decade_loudness,
             decade_time_signature, decade_mode, decade_key_char)

##---
# Some cleaning should be done based one decade observations
table(data_df$Decade)

#the amount of songs that were able to be pulled is not too bad so I will not
#about down sampling to even out the data
#Yes 2020 will have a significant data set, it only has 2 years of songs

##Check to see if any missing values
apply(data_df, 2, function(x) any(is.na(x)))

##According to Spotify documentation Time Signature should not be below 3
##Will delete those rows

data_clean <- data_df%>%
  subset(time_signature >= 3)


#no missing values


##Lets take a look at the features with the genres

print(table(data_clean$Genre))

#Since there are so many low valued genres I will remove any values lower than 10

data_count <- data_clean %>%                              # Applying group_by & summarise
  count(Genre)

data_clean <- merge(data_clean, data_count, by='Genre')

#I noticed I have misslabeled some of the genres those should be removed
#Some of the genres also do not seem to hold great significance as they have a low count
#These rows will be removed as well
data_clean2 <- data_clean%>%
  subset(n >= 50)

table(data_clean2$Genre)
table(data_clean2$Decade)

##lets take a look at the features correlations really quickly 
data_features <- data_clean2%>%
  select(-c(Song.Title, Artist, Year, key_character, n, n_mode, mode_char, Genre,
            Decade, key, time_signature, mode, Rank))

genres_decades <- (ggplot(data_clean2, aes(x= factor(Decade, decade_order))) +
                     geom_bar(aes(fill=Genre)) + xlab('Decade') +
                     ggtitle('Genres Through the Decades')
)
genres_decades

data_clean2<-data_clean2%>%
  select(-c(n, n_mode))


pairs.panels(data_features)
dev.off()
corPlot(data_features)



##extra
##seeing the regression against all other variables

vars <- names(data_features) # we can eliminate the dates

forms <- lapply(1:length(vars),
                function(i) formula(paste(vars[i], "~", paste(vars[-i], collapse = "+")))
)

for (i in 1:10){
  print(forms[[i]])
  print(vif(lm(forms[[i]], data=data_features)))
}
mods <- lapply(forms, lm, data = data_features)

mods





##the data is now fully clean
##And the genres which were mislabeled or irrelevant when I was manually
##imputing the data has been cleaned

#export the clean data

write.csv(data_clean2, file = "C:/Users/sneaz/Documents/ML/Data/Song Features/clean_feature_data.csv")




