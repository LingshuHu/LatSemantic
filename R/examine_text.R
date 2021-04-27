df1 <- rtweet::read_twitter_csv("data/covid_usa_jan24-mar10_21pm-23pm_onethird_text_clean.csv")
df2 <- rtweet::read_twitter_csv("data/covid_usa_mar11-may25_21pm-23pm_onethird_text_clean.csv")

dfs <- df1[grepl("army", df1$textp)&grepl("covid19", df1$textp),]
dfs <- dfs[!duplicated(dfs$textp), ]
txt <- data.frame(id = 1:203, text = dfs$text)
write.csv(txt, "results/army&covid.csv")
  writeLines(dfs$text, "results/army&covid.txt") 

dfs <- df1[grepl("hoax", df1$textp)&grepl("covid19", df1$textp),]
dfs <- df2[grepl("radiation", df2$textp)&grepl("covid19", df2$textp),]
dfs <- dfs[!duplicated(dfs$textp), ]
txt <- data.frame(id = nrow(dfs), text = dfs$text)
write.csv(txt, "results/hoax&covid.csv")



#####
files <- list.files("data_week/usa", full.names = T)

key_sample <- vector("list", length = length(files))
for (i in seq_along(files)) {
  df <- rtweet::read_twitter_csv(files[i])
  keydf <- df[grepl("flu", df$text, ignore.case = T)& #frontlines?; 5G; fight; hoax; flu
                grepl("covid19|covid|coronavirus", df$text, ignore.case = T),]
  if (nrow(keydf) > 1000) {
    set.seed(123)
    keydf <- dplyr::sample_n(keydf, 1000)
  }
  key_sample[[i]] <- keydf
}

key_sample <- do.call("rbind", key_sample)
key_sample <- key_sample[!duplicated(key_sample$text), ]

rtweet::write_as_csv(key_sample, "sample_texts/flu_week1-10.csv") # frontline; 5g; fight; hoax; flu
rtweet::write_as_csv(key_sample[, 1:5], "sample_texts/flu_week1-10_texts.csv")
