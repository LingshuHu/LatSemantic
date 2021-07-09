
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




