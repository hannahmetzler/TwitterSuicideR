#to get data in the format in which it is read in below, first do in bash terminal: 

#file with date and id
# with zcat extract the date and id, with awk print the "fields separated by space, 
#then separate again by comma and insert tab instead of comma, 
#with replace/delete some characters using sed, seperating the instances to replace with ;
# 1. delete the " at start of each line, 2. replace the \" around every cell with only ",
# 3. delete the first 5 characters of each line, because they include the weekdays which R cannot interpret, and replace only with "
# zcat tweet_ids_set_rehydrated-time_id_text.csv.gz | awk -F ' ' '{print  $1" "$2" "$3" "$6}' | awk -F "," '{print $1"'\\t'"$2}' | sed 's/"//; s/\\"/"/g ; s/^...../"/' > tweet_date_id

#libraries
library(dplyr)

#read data predictions from Hubert's model
dp <- read.csv('tweets_other_datasets/Suicide_all_predictions.csv', stringsAsFactors=F, sep='\t', colClasses = "character") %>%
  mutate(predictions = factor(predictions)) %>% 
  rename(id = ID) 
length(unique(dp$id)) #9'583'146

#read data with retweets
drt<- read.table('tweets_other_datasets/Suicide_all_ids-rts.txt', sep=',', header=F, colClasses = "character") %>%
  rename(id = V1,
         rt = V2)
#includes only unique ids

#read data with date
dd = read.table("tweets_other_datasets/tweet_date_id", sep='\t',  colClasses = "character")
#so dates and times can be read in English: set language and time zone
Sys.setlocale("LC_TIME", 'en_US.UTF-8')
dd1 = dd %>% 
  rename(date = V1,
         id = V2) %>% 
  mutate(date = as.Date(date, format = "%B %d %Y"))
length(unique(dd1$id)) #9'583'690

  # Number of tweets in each dataset, & unique ids: 

#* Predictions (dp): 13'427'524 & 9'583'146
#* Date (dd):        13'428'072 & 9'583'690
#* Retweets (drt):    8'891'990 & 8'891'990

#* Predictions + dates (ddp): 21'116'584
#* Predictions + dates + RT (ddprt):        19'290'938


#join the three datasets- 1: predictions and dates
ddp = dp %>% 
  inner_join(dd1) %>% 
  group_by(id) %>%
    filter(row_number() <=1)
#2: retweets
ddprt = ddp %>% 
inner_join(drt)
ddprt1 = ddprt %>% 
  select(-text_original) %>% 
  arrange(id)

#entries: 19'290'938 

summary(ddprt1)
#unique tweet ids:# 8'752'126
length(unique(ddprt1$id))

