#libraries
library(dplyr)
library(lubridate)
library(stringr)
library(beepr) # to beep after a long analysis is finished

#set date format to english
Sys.setlocale("LC_ALL", 'en_US.UTF-8')

#new predictions file based on Crimson Hexagon query including Retweets, to get more precise estimate per day
dp = read.csv('full_tweet_set_for_predictions_withRTs_inquery/twitter_14M_with_predictions_withRTs.csv', stringsAsFactors=F, sep='\t', colClasses = "character")
#retweet count
rt = read.csv('full_tweet_set_for_predictions_withRTs_inquery/rts.csv', stringsAsFactors=F, sep='\t', colClasses = "character", header=F) %>% 
  rename(rt_original_tweet = V1)
#is tweet a retweet or not? if yes, id of original tweet, if no, null
isrt = read.csv('full_tweet_set_for_predictions_withRTs_inquery/isrt.csv', stringsAsFactors=F, sep='\t', colClasses = "character", header=F) 
  rename(retweet = V1) 
 #recode tweet ids to 1, null to 0, for true/false
  mutate(retweet = if_else(retweet == "null", 0, 1))
dp1 = cbind(dp, rt, isrt) %>% 
  mutate(main_category = factor(main_category), 
         about_suicide = factor(about_suicide)) %>% 
  #rename factor levels and variables
  rename(id = ID) %>% 
  mutate(about_suicide = factor(about_suicide, labels = c("yes", "no"))) %>% 
  rename(about_suicide_prediction = about_suicide, 
         main_category_prediction = main_category) %>% 
  mutate(rt_original_tweet = as.numeric(rt_original_tweet), 
         #format date
         date = as.Date(time, format = "%B %d %Y")) %>% 
  #delete time column
  select(-time)

str(dp1)
nrow(dp1)

#first and last date
dp2 = arrange(dp1, date) %>% 
  group_by(id)

head(dp2)
tail(dp2)

# Calculate tweet volume per day ####

Sys.setlocale("LC_TIME", 'en_US.UTF-8')

#tweets per main category
dcatperday = dp1 %>% 
  group_by(date) %>% 
  #total volume per date
  mutate(ndaytotal = n()) %>% 
  #volume per category
  group_by(date, ndaytotal, main_category_prediction, retweet) %>% 
  summarise(ntweets = n()) %>% 
  #create variable for year, month and weekday
  mutate(year = lubridate::year(date), 
         month = lubridate::month(date, label=T), 
         weekday = lubridate::wday(date, label=T)) %>% 
  #delete december 31st 2012, and 14 days in April 2020
  filter(date != as.Date("2015-12-31")) %>% 
  mutate(retweet = factor(retweet, levels = c(0,1), labels = c("original", "retweet")))%>% 
  rename(type = "retweet")

#tweets about suicide per day
dsuiperday = dp1%>% 
   group_by(date) %>% 
  mutate(ndaytotal =n()) %>% 
  group_by(date, ndaytotal, about_suicide_prediction, retweet) %>% 
  summarise(ntweets = n()) %>% 
  #create variable for year, month and weekday
  mutate(year = lubridate::year(date), 
         month = lubridate::month(date, label=T), 
         weekday = lubridate::wday(date, label=T)) %>% 
  #delete december 31st 2012, and 14 days in April 2020
  filter(date != as.Date("2015-12-31")) %>% 
  mutate(retweet = factor(retweet, levels = c(0,1), labels = c("original", "retweet"))) %>% 
  rename(type = "retweet")

#write to different data formats ####
library(haven)

#main category datafiles
save(dcatperday, file="data_tweet_volumes/Suicide_tweets_daily_volume_per_maincategory_withRTs.R")
write.csv2(dcatperday, "data_tweet_volumes/Suicide_tweets_daily_volume_per_maincategory_withRTs.csv", row.names=F)
write_sav(dcatperday, "data_tweet_volumes/Suicide_tweets_daily_volume_per_maincategory_withRTs.sav")

#about suicide datafiles
save(dsuiperday, file="data_tweet_volumes/Suicide_tweets_daily_volume_aboutsuicide_withRTs.R")
write.csv2(dsuiperday, "data_tweet_volumes/Suicide_tweets_daily_volume_aboutsuicide_withRTs.csv", row.names=F)
write_sav(dsuiperday, "data_tweet_volumes/Suicide_tweets_daily_volume_aboutsuicide_withRTs.sav")
  