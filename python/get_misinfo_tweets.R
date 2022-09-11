
## data are from https://github.com/cuilimeng/CoAID
library(rtweet)

## get all the file names
lstf1 <- list.files("misinfo_tweets/CoAID-master", full.names = T)
lstf2 <- vector("list")
for (i in seq_along(lstf1[1:4])) {
  lstf2[[i]] <- list.files(lstf1[i], full.names = T)
}
lstf2[1]
lstf2 <- unlist(lstf2)

## tweets or news articles
lsttweets <- lstf2[grepl("tweets(_|\\.)",lstf2)]
lstnews <- lstf2[!grepl("tweets(_|\\.)",lstf2)]

## tweets or replies
lsttweets_fake <- lsttweets[grepl("Fake", lsttweets) & !grepl("replies", lsttweets)]
lsttweets_real <- lsttweets[grepl("Real", lsttweets) & !grepl("replies", lsttweets)]

lsttweets_fake_reply <- lsttweets[grepl("Fake", lsttweets) & grepl("replies", lsttweets)]
lsttweets_real_reply <- lsttweets[grepl("Real", lsttweets) & grepl("replies", lsttweets)]

## get fake tweets 
tweets_statuses_fake <- vector("list", length = length(lsttweets_fake))
for (i in seq_along(lsttweets_fake)) {
  tweets_statuses_fake[[i]] <- rtweet::read_twitter_csv(lsttweets_fake[i])
}

tweets_statuses_fake <- do.call("rbind", tweets_statuses_fake)
tweets_statuses_fake <- tweets_statuses_fake[!duplicated(tweets_statuses_fake$tweet_id), ]

tw_fake <- lookup_statuses(tweets_statuses_fake$tweet_id)

rtweet::write_as_csv(tw_fake, "misinfo_tweets/CoAID_fake_tweets_3717.csv")

## get real tweets
tweets_statuses_real <- vector("list", length = length(lsttweets_real))
for (i in seq_along(lsttweets_real)) {
  tweets_statuses_real[[i]] <- rtweet::read_twitter_csv(lsttweets_real[i])
}

tweets_statuses_real <- do.call("rbind", tweets_statuses_real)
tweets_statuses_real <- tweets_statuses_real[!duplicated(tweets_statuses_real$tweet_id), ]

tw_real <- lookup_statuses(tweets_statuses_real$tweet_id)
which(tweets_statuses_real$tweet_id == tw_real$status_id[33037])

tw_real2 <- lookup_statuses(tweets_statuses_real$tweet_id[78912:145189])
tw_real <- rbind(tw_real, tw_real2)

rtweet::write_as_csv(tw_real, "misinfo_tweets/CoAID_real_tweets_61366.csv")

## combine fake and real
tw_real$label <- "real"
tw_fake$label <- "fake"

tw <- rbind(tw_fake, tw_real)
#tw <- tw[tw$lang == "en", ]
rtweet::write_as_csv(tw, "misinfo_tweets/CoAID_fake+real_tweets.csv")
