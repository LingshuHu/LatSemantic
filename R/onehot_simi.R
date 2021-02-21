
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
df1 <- rtweet::read_twitter_csv("data/covid_usa_jan24-mar10_21pm-23pm_onethird_text_clean.csv")
df2 <- rtweet::read_twitter_csv("data/covid_usa_mar11-may25_21pm-23pm_onethird_text_clean.csv")

dv1 <- quanteda::dfm(df1$textp)
dv2 <- quanteda::dfm(df2$textp)

s1 <- quanteda::textstat_simil(dv1[, c("covid19", "usa")],  method = "cosine", margin = "features")
s1@x[2] ## extract the similarity score

## get all pairs
race <- c("black", "africa", "african", "melanin", "poc")
racemis <- c("genocide", "immune", "immunity", "inoculated", "depopulate", "depopulation", "vitamin", "vit", "zinc", "supplements", "garlic", "water", "colloid", "vaccine", "vaccinate", "vaccination")

race <- c("black", "melanin", "poc")
racemis <- c("genocide", "immunity", "inoculated", "depopulation", "vitamin", "vit", "zinc", "supplements", "garlic", "water", "colloid", "vaccine")

covidmis <- "unreported, 5G, radiation, electromagnetic, Chip, microchip, microchipping, implant, Gates, Hoax, Overblown, flu, Bleach, chlorine, Antibiotics"
covidmis <- unlist(strsplit(tolower(covidmis), split = ", "))

covid_pair <- tidyr::crossing(X1 = "covid19", X2 = covidmis)
race_pair <- tidyr::crossing(X1 = race, X2 = racemis)
other_pair <- data.frame(rbind(c("mandatory", "vaccine"), c("overcount", "death"), c("dioxide", "mask"), c("lab", "china")))

all_pair <- rbind(covid_pair, race_pair, other_pair)

## calculate similarities between all pairs
multi_simi <- function(wordpairs, dfm) {
  s <- vector("list", length = nrow(wordpairs))
  for (i in seq_along(wordpairs[[1]])) {
    wd1 <- wordpairs[[1]][i]
    wd2 <- wordpairs[[2]][i]
    if (wd1 %in% dfm@Dimnames$features & wd2 %in% dfm@Dimnames$features) {
      vecs <- dfm[, c(wd1, wd2)]
      obj <- quanteda::textstat_simil(vecs,  method = "cosine", margin = "features")
      s[[i]] <- obj@x[2]
    } else {s[[i]] <- 9}
    
  }
  return(s)
}

all_s1 <- unlist(multi_simi(all_pair, dv1))
all_s2 <- unlist(multi_simi(all_pair, dv2))
all_pair_simi <- data.frame(all_pair, before = all_s1, after = all_s2)

write.csv(all_pair_simi, "results/covid_misinfo_onehot.csv")

unlist(covid_s)
