#wordclouds to identify peaks per category
#libraries
library(dplyr)
library(lubridate)
library(stringr)
library(beepr) # to beep after a long analysis is finished

#set date format to english
Sys.setlocale("LC_ALL", 'en_US.UTF-8')

#new predictions file based on Crimson Hexagon query including Retweets, to get more precise estimate per day
dp = read.csv('full_tweet_set_for_predictions_withRTs_inquery/twitter_14M_with_predictions_withRTs.csv', stringsAsFactors=F, sep='\t', colClasses = "character")

dp = dp %>% 
  mutate(main_category = factor(main_category), 
         about_suicide = factor(about_suicide))

dp = dp %>% 
  mutate(date = lubridate::myd(time))
summary(dp)


#format the timestamp column to identical date format
d = d %>% 
  #types of formats that exist in the dataset
  #1: Mon Mar 04 19:52:34 +0000 2019 "%a %b %d %H:%M:%S +0000 %Y", 
  #2: 12/28/19 12:52 AM "%Y/%m/%d %h:%M"
  #3: 2017-02-27 23:07:40 "%Y-%m-%d %H:%M:%S"
  #recode to common format: yyyy-mm-dd
  mutate(date = case_when(
    str_detect(timestamp, "0000") == TRUE  ~ as.Date(timestamp, format = "%a %b %d %H:%M:%S +0000 %Y"), #2184 NAs, type b
    str_detect(timestamp, "/") == TRUE     ~ as.Date(timestamp, format = "%m/%d/%Y %I:%M"), #2502 NAs, type c
    str_detect(timestamp, "-") == TRUE     ~ as.Date(timestamp, format = "%Y-%m-%d %H:%M:%S") #2596 NAs, type a
  )) %>% 
  mutate(date = lubridate::ymd(date))

dp %>%
  filter(main_category=="prevention" & month=="Dec" )