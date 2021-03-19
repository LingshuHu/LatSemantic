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
