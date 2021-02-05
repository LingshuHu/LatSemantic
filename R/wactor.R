
library(wactor)

df <- data.frame(id = 1:5, 
                 text = c("this is first sentence", "this is the second one one one", "third one", "another one", "final"),
                 stringsAsFactors = F)

#w <- wactor::wactor(df$text)
#d <- wactor::dtm(w)

d <- quanteda::dfm(df$text)

this <- quanteda::dfm_select(d, "this")

quanteda::textstat_simil(d[, c("this", "is")],  method = "cosine", margin = "features")
                         