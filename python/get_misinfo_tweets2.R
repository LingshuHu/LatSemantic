

## https://github.com/SakibShahriar95/ANTiVax
library(rtweet)
options(scipen=999)

df <- rtweet::read_twitter_csv("misinfo_tweets/ANTiVax-main/Labeled/VaxMisinfoData.csv")
colnames(df)[1] <- "status_id"
str(tw$status_id)

tw <- lookup_statuses(df$status_id)

df$status_id <- as.character(df$status_id)
tw <- dplyr::left_join(tw, df, by = "status_id")
table(tw$is_misinfo)

rtweet::write_as_csv(tw, "misinfo_tweets/ANTiVax_tweets_with_label.csv")
rtweet::write_as_csv(tw[, c("status_id", "text", "is_misinfo")], "misinfo_tweets/ANTiVax_tweets_text_with_label.csv")
