
###################### find frequency of metaphor and misinfo words ################
#install.packages("jsonlite")
## function to count words matches in a dictionary
word_match <- function(x, dict) {
  if (is.character(x)) {
    ## this removes URLs
    #x <- gsub("https?://\\S+|@\\S+", "", x)
    x <- tokenizers::tokenize_words(
      x, lowercase = TRUE, strip_punct = TRUE, strip_numeric = FALSE
    )
  }
  word_count <- function(token) {
    total_words_count <- length(token)
    med_words_count <- sum(dict$value[match(token, dict$word)], na.rm = TRUE)
    med_words_ratio <- med_words_count/total_words_count
    data.frame(total_words_count = total_words_count,
               med_words_count = med_words_count,
               stringsAsFactors = FALSE)
  }
  #count <- lapply(x, word_count)
  #count <- do.call("rbind", count)
  count <- word_count(x)
}


kw <- jsonlite::fromJSON("data/all_keywords_pairs.json", flatten = T)
kw <- unique(kw[,1])
kw <- data.frame(word = kw, value = rep(1, length(kw)))


files <- list.files("data_week_text/usa", full.names = T)
tt <- readLines(files[1])
stringr::str_count(tt[1], "co")
tt1 <- stringr::str_c(tt, collapse = " ")

frq <- vector("list", length = nrow(kw))
for (i in seq_along(kw$word)) {
  frq[[i]] <- word_match(tt1, kw[i, ])
}

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
  



