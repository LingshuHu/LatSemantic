
# https://www.slideshare.net/dileepajayakody/w-40109236 # random indexing slides

library(wactor)

df <- data.frame(id = 1:5, 
                 text = c("this is first sentence", "this is the second one one one", "third one", "another one", "final"),
                 stringsAsFactors = F)

#w <- wactor::wactor(df$text)
#d <- wactor::dtm(w)

d <- quanteda::dfm(df$text)

this <- quanteda::dfm_select(d, "this")

quanteda::textstat_simil(d[, c("this", "is")],  method = "cosine", margin = "features")


## read data
df <- rtweet::read_twitter_csv("data/covid_usa_jan24-mar10_21pm-23pm_onethird_text_clean.csv")

dv <- quanteda::dfm(df$text.1)
s <- quanteda::textstat_simil(dv[, c("covid19", "china")],  method = "cosine", margin = "features")
s@x[2] ## extract the similarity score
