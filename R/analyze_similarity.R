
###################### find frequency and similarity of metaphor and misinfo words ################
#install.packages("jsonlite")
kw <- jsonlite::fromJSON("data/all_keywords_pairs.json", flatten = T)
met <- kw[1:101, 1]
met <- unique(met)
mis1 <- kw[102:179, 1]
mis2 <- kw[116:179, 2]
mis <- unique(c(mis1, mis2))

simi <- read.csv("results/simi_usa01-52_word2vec_non-neg.csv", stringsAsFactors = F)
colnames(simi) <- c("word1", "word2", paste0("week", 1:52))


fs <- list.files("results/usa", full.names = T)

met_freq <- vector("list", length = length(fs))
mis_freq <- vector("list", length = length(fs))
for (i in seq_along(fs)) {
  df <- read.csv(fs[i], stringsAsFactors = F)
  df[is.na(df)] <- 0
  df$rate <- 100*df$frequency/df$total_words
  met_df <- subset(df, words %in% met)
  met_df <- dplyr::left_join(met_df, simi[1:101, c("word1", paste0("week", i))], by = c("words" = "word1"))
  colnames(met_df)[6] <- "similarity"
  met_freq[[i]] <- met_df[order(met_df$rate, decreasing = T), ]
}

met_freq <- do.call("cbind", met_freq)

write.csv(met_freq, "results/top_met_words_by_weeks.csv", row.names = F)

#######################
## similarity among 5 top words
simi <- read.csv("results/simi_usa01-52_word2vec_non-neg_all_connections.csv", stringsAsFactors = F)
colnames(simi) <- c("word1", "word2", paste0("week", 1:52))
simi$pairs <- paste(simi$word1, simi$word2, sep = "-")
fs <- list.files("results/usa", full.names = T)

top_met_simis <- vector("list", length = length(fs))
#mis_freq <- vector("list", length = length(fs))
for (i in seq_along(fs)) {
  df <- read.csv(fs[i], stringsAsFactors = F)
  df[is.na(df)] <- 0
  df$rate <- 100*df$frequency/df$total_words
  met_df <- subset(df, words %in% met)
  met_df <- met_df[order(met_df$rate, decreasing = T), ]
  met_df <- met_df[1:5, ]
  w1 <- vector("list", length = 5)
  for (x in seq_along(met_df$words)) {
    w2 <- vector("list", length = 5)
    for (y in seq_along(met_df$words[x:5])) {
      w2[[y]] <- paste(met_df$words[x], met_df$words[x:5][y], sep = "-")
    }
    w1[[x]] <- unlist(w2) 
  }
  pairs <- data.frame(pairs = unlist(w1))
  pairs <- dplyr::left_join(pairs, simi[, c("pairs", paste0("week", i))], by = "pairs")
  #colnames(pairs)[6] <- "similarity"
  top_met_simis[[i]] <- pairs
}

top_met_simis <- do.call("cbind", top_met_simis)
write.csv(top_met_simis, "results/top_met_words_by_weeks_all_connections.csv", row.names = F)

#####################################
## read data
df <- read.csv("results/simi_usa01-52_word2vec_non-neg.csv")
weeks <- unlist(lapply(1:52, function(x) paste0("week", x)))
colnames(df) <- c("word1", "word2", weeks)

df[df == 9] <- NA

avg_simi <- apply(df[,3:54], 1, mean, na.rm = T)

df <- cbind(df, avg_simi)


df_met <- df[1:101, ]
df_met <- df_met[order(df_met$avg_simi, decreasing = T), ]
df_met[1:40, c("word1", "word2", "avg_simi")]

## visualize
library(ggplot2)
df_met_long <- tidyr::gather(df_met[1:5, ], key = "weeks", value = "value",  3:54)
df_met_long$weeks <- sub("week", "", df_met_long$weeks)
df_met_long$weeks <- as.integer(df_met_long$weeks)

ggplot(df_met_long, aes(x = weeks, y = value, group = word1, color = word1)) + geom_line()

ggplot(df_met_long, aes(x = weeks, y = value, group = word1, color = word1)) + 
  geom_point() + geom_smooth(se = F)
  



