library(arules)
library(arulesViz)



sixties <-"https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_60s.csv"
seventies <- "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_70s.csv"
eighties <- "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_80s.csv"
ninties <- "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_90s.csv"
twothousand <- "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_2000s.csv"
twoten <- "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_2010s.csv"
twotwo <- "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_2020s.csv"


data_list <- list(sixties, seventies, eighties, ninties, twothousand, twoten, twotwo)


file_name <- sixties


inspect(top_song_lyrics)
summary(top_song_lyrics)


top_song_lyrics <- read.transactions(file_name,
                                     rm.duplicates=FALSE,
                                     format="basket",
                                     sep=",")


lyrics_rules = arules::apriori(top_song_lyrics,
                               parameter = list(support=.01, confidence=.0001,
                                                minlen=2, maxlen=10))
inspect(lyrics_rules[1:10])
sort_rules_sup <- sort(lyrics_rules, by="support", decreasing = TRUE)
sort_rules_con <- sort(lyrics_rules, by="confidence", decreasing = TRUE)
inspect(sort_rules_sup[1:10])
inspect(sort_rules_con[1:10])

lyrics_rules_love = arules::apriori(top_song_lyrics,
                                    parameter = list(support=.01, confidence=.0001,
                                                     minlen=2, maxlen=10),
                                    appearance = list(rhs = c("love"),
                                                      default="lhs"))
inspect(lyrics_rules_love[1:10])
sort_rules_sup_love <- sort(lyrics_rules_love, by="support", decreasing = TRUE)
sort_rules_con_love <- sort(lyrics_rules_love, by="confidence", decreasing = TRUE)
inspect(sort_rules_sup_love[1:10])
inspect(sort_rules_con_love[1:10])

plot(sort_rules_sup[1:10], method="graph", engine = "htmlwidget", shading="confidence")
