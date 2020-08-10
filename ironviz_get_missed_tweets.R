library(rtweet)
library(dplyr)

# Load data
ironviz <- readRDS("data/#ironviz_tweets.RDS")

# Find missing tweet
#missing <- lookup_tweets(c('1290939514177937408','1290952501508943872','1290908538349342721'))

# Merge with ironviz tweets
#ironviz <- rbind(ironviz,missing)

# Save data
saveRDS(ironviz,"data/#ironviz_tweets.RDS")

