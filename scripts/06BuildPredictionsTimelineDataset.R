#to get data in the format in which it is read in below, first do in bash terminal: 

#file with date and id
zcat tweet_ids_set_rehydrated-time_id_text.csv.gz | awk -F ' ' '{print $2" "$3" "$6}' | awk -F "," '{print $1"'\\t'"$2}' | sed 's/\\"//g' > tweet_date_id


#libraries
library(dplyr)

#read data predictions from Hubert's model
dp <- read.csv('tweets_other_datasets/Suicide_all_predictions.csv', stringsAsFactors=F, sep='\t') %>%
  mutate(predictions = factor(predictions), 
         ID = as.character(ID)) %>% 
  rename(id = ID)

#read data with retweets
drt<- read.table('tweets_other_datasets/Suicide_all_ids-rts.txt', sep=',', header=F) %>%
  rename(id = V1,
         rt = V2) %>% 
  mutate(id = as.character(id))

#read data with date
dd = read.table("tweets_other_datasets/tweet_date_id", sep='\t')
#so dates and times can be read in English: set language and time zone
Sys.setlocale("LC_TIME", 'en_US.UTF-8')
dd1 = dd %>% 
  rename(date = (V1),
         id = V2) %>% 
  mutate(id = as.character(id)) %>% 
  mutate(date = as.Date(date, format = "%B %d %Y"))

# Number of tweets in each dataset

#* Predictions (dp): 13'427'524
#* Date (dd):        13'428'072 
#* Retweets (drt):    8'891'990

#* Predictions + dates: 21'116'584
#* same plus RT:        19'290'938


#join the three datasets- 1: predictions and dates
ddp = dp %>% 
  inner_join(dd1)
#2: retweets
ddprt = ddp %>% 
inner_join(drt)
ddprt1 = ddprt %>% 
  select(-text_original)

#entries: 19'290'938 

summary(ddprt1)
#unique tweet ids:# 8'752'126
length(unique(ddprt1$id))

