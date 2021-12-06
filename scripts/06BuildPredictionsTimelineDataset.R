#to get data in the format in which it is read in below (Suicide_all_predictions.csv), first do in bash terminal: not necessary anymore with Hubert's new dataset, because it already includes dates
#file with date and id
# with zcat extract the date and id
# with awk print the "fields" separated by space, #then separate again by comma and insert tab instead of comma (-F is the field separator, each $ refers to a field (i.e. piece of text in between 2 field separator symbols))
# with replace/delete some characters using sed, seperating the instances to replace with ;
# 1. delete the " at start of each line, 2. replace the \" around every cell with only ",
# 3. delete the first 5 characters of each line, because they include the weekdays which R cannot interpret, and replace only with "
  # zcat tweet_ids_set_rehydrated-time_id_text.csv.gz | awk -F' ' '{print  $1" "$2" "$3" "$6}' | awk -F, '{print $1"'\\t'"$2}' | sed 's/"//; s/\\"/"/g ; s/^...../"/' > tweet_date_id


#libraries
library(dplyr)
library(lubridate)
library(stringr)
library(beepr) # to beep after a long analysis is finished

#set date format to english
Sys.setlocale("LC_ALL", 'en_US.UTF-8')

#read data predictions from Hubert's model: BERT, trained on unbalanced dataset (no articificial data)
dp <- read.csv('tweets_other_datasets/twitter_13M_with_predictions.csv', stringsAsFactors=F, sep='\t', colClasses = "character") %>% #colnames: time ID text main_category about_suicide
  mutate(main_category = factor(main_category),
         about_suicide = factor(about_suicide)) %>%
  rename(id = ID) %>%
  #delete the +0000 in the time string, split before and after, and rename each substring
  mutate(time = str_split_fixed(time, " \\+0000 ", n=2)) %>%
  mutate(year = time[,2],
         date_time = time[,1]) %>%
  #delete the matrix with both substrings
  select(-time) %>%
  #join date/time + year together, and reformat the resulting date to yyyy-mm-dd
  mutate(time = str_c(date_time, year, sep = " "),
         date = as.Date(time, format = "%a %b %e %H:%M:%S %Y")) %>%
  select(-c(date_time, time, year))


  # length(unique(dp$id)) #9 583 294, rows: 13 427 526

#read data with retweets
drt<- read.table('tweets_other_datasets/Suicide_all_ids-rts.txt', sep=',', header=F, colClasses = "character") %>%
  rename(id = V1,
         rt = V2) %>% 
  mutate(rt = as.numeric(rt))
#includes only unique ids

# total number of tweets: unique ids plus retweets
nrow(drt)+sum(drt$rt) # 21.709.809 tweets

# #read data with date - already included in the new predictions datafile (twitter_13M_with_predictions.csv, only needed if working with the file Suicide_all_predictions.csv)
# dd = read.table("tweets_other_datasets/tweet_date_id", sep='\t',  colClasses = "character")
# #so dates and times can be read in English: set language and time zone
# Sys.setlocale("LC_TIME", 'en_US.UTF-8')
# dd1 = dd %>% 
#   rename(date = V1,
#          id = V2) %>% 
#   mutate(date = as.Date(date, format = "%B %d %Y"))
# # length(unique(dd1$id)) #9'583'690


# Number of tweets in each dataset, & unique ids: 

#* Predictions (dp): 13'427'524 & 9'583'146
#* Date (dd):        13'428'072 & 9'583'690
#* Retweets (drt):    8'891'990 & 8'891'990

#* Predictions + dates (ddp):        21'116'584 (without cleaning for duplicates) & 9'583'293
#* Predictions + dates + RT (ddprt): 19'290'938 (without cleaning for duplicates) & 8'752'258


#join the datasets #### 
# #1: predictions and dates
# ddp = dp %>% 
#   inner_join(dd1) %>% 
#   group_by(id) %>%
#   slice(1) #keep only unique id entries
# # length(unique(ddp$id)) #  9'583'293

#step 2: predictions/dates dataset and retweet dataset
ddprt = dp %>% #ddp
  inner_join(drt) %>% 
  group_by(id) %>%
  slice(1) #keep only unique id entries
# length(unique(ddprt$id)) # 8'752'258

#reorder columns
ddprt = ddprt[,c("id", "date","rt","main_category_prediction", "about_suicide_prediction", "text")]
beep()

# Calculate tweet volume per day ####

# total tweets of each tweet: 1 + the retweets
Sys.setlocale("LC_TIME", 'en_US.UTF-8')
dcatperday = ddprt %>% 
  mutate(ntweets = rt+1) %>% 
  group_by(date) %>% 
  mutate(ndaytotal = sum(ntweets)) %>% 
  group_by(date, ndaytotal, main_category_prediction) %>% 
  summarise(ntweets = sum(ntweets), 
            nRT = sum(rt)) %>% 
  #create variable for year, month and weekday
  mutate(year = lubridate::year(date), 
         month = lubridate::month(date, label=T), 
         weekday = lubridate::wday(date, label=T)) %>% 
#delete december 31st 2012, and 14 days in April 2020
  filter(date != as.Date("2012-12-31"))

#tweets about suicide per day
dsuiperday = ddprt%>% 
  mutate(ntweets = rt+1) %>% 
  group_by(date) %>% 
  mutate(ndaytotal = sum(ntweets)) %>% 
  group_by(date, ndaytotal, about_suicide_prediction) %>% 
  summarise(ntweets = sum(ntweets), 
            nRT = sum(rt)) %>% 
  #create variable for year, month and weekday
  mutate(year = lubridate::year(date), 
         month = lubridate::month(date, label=T), 
         weekday = lubridate::wday(date, label=T)) %>% 
  #delete december 31st 2012, and 14 days in April 2020
  filter(date != as.Date("2012-12-31"))

#write to different data formats ####
library(haven)

#main category datafiles
save(dcatperday, file="data_tweet_volumes/Suicide_tweets_daily_volume_per_maincategory.R")
write.csv2(dcatperday, "data_tweet_volumes/Suicide_tweets_daily_volume_per_maincategory.csv", row.names=F)
write_sav(dcatperday, "data_tweet_volumes/Suicide_tweets_daily_volume_per_maincategory.sav")

#about suicide datafiles
save(dsuiperday, file="data_tweet_volumes/Suicide_tweets_daily_volume_aboutsuicide.R")
write.csv2(dsuiperday, "data_tweet_volumes/Suicide_tweets_daily_volume_aboutsuicide.csv", row.names=F)
write_sav(dsuiperday, "data_tweet_volumes/Suicide_tweets_daily_volume_aboutsuicide.sav")
