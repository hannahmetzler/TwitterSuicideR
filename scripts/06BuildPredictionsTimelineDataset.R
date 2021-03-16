#to get data in the format in which it is read in below, first do in bash terminal: 

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

#read data predictions from Hubert's model
dp <- read.csv('tweets_other_datasets/Suicide_all_predictions.csv', stringsAsFactors=F, sep='\t', colClasses = "character") %>%
  mutate(predictions = factor(predictions)) %>% 
  rename(id = ID) 
# length(unique(dp$id)) #9'583'146

#read data with retweets
drt<- read.table('tweets_other_datasets/Suicide_all_ids-rts.txt', sep=',', header=F, colClasses = "character") %>%
  rename(id = V1,
         rt = V2) %>% 
  mutate(rt = as.numeric(rt))
#includes only unique ids

#read data with date
dd = read.table("tweets_other_datasets/tweet_date_id", sep='\t',  colClasses = "character")
#so dates and times can be read in English: set language and time zone
Sys.setlocale("LC_TIME", 'en_US.UTF-8')
dd1 = dd %>% 
  rename(date = V1,
         id = V2) %>% 
  mutate(date = as.Date(date, format = "%B %d %Y"))
# length(unique(dd1$id)) #9'583'690


# Number of tweets in each dataset, & unique ids: 

#* Predictions (dp): 13'427'524 & 9'583'146
#* Date (dd):        13'428'072 & 9'583'690
#* Retweets (drt):    8'891'990 & 8'891'990

#* Predictions + dates (ddp):        21'116'584 (without cleaning for duplicates) & 9'583'293
#* Predictions + dates + RT (ddprt): 19'290'938 (without cleaning for duplicates) & 8'752'258


#join the three datasets #### 
#1: predictions and dates
ddp = dp %>% 
  inner_join(dd1) %>% 
  group_by(id) %>%
  slice(1) #keep only unique id entries
# length(unique(ddp$id)) #  9'583'293

#step 2: add the retweets
ddprt = ddp %>% 
  inner_join(drt) %>% 
  group_by(id) %>%
  slice(1) #keep only unique id entries
# length(unique(ddprt$id)) # 8'752'258

#reorder columns
ddprt = ddprt[,c("id", "date","rt","predictions", "text_original")]
beep()

# Calculate tweet volume per day ####

# total tweets of each tweet: 1 + the retweets
Sys.setlocale("LC_TIME", 'en_US.UTF-8')
dcatperday = ddprt %>% 
  mutate(ntweets = rt+1) %>% 
  group_by(date, predictions) %>% 
  summarise(ntweets = sum(ntweets)) %>% 
  #create variable for year, month and weekday
  mutate(year = lubridate::year(date), 
         month = lubridate::month(date, label=T), 
         weekday = lubridate::wday(date, label=T)) %>% 
  mutate(monthyear = paste(month, year)) %>% 
#delete december 31st 2012, and 14 days in April 2020
  filter(date != as.Date("2012-12-31"))

# save(dcatperday, file="tweets_other_datasets/Suicide_tweets_daily_volume_per_maincategory.R")


