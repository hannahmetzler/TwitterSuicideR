#how many tweets mention a lifeline or suicide hotline or their number/twitter account?

library(dplyr)
library(lubridate)

#new predictions file based on Crimson Hexagon query including Retweets, to get more precise estimate per day
dp = read.csv('full_tweet_set_for_predictions_withRTs_inquery/twitter_14M_with_predictions_withRTs_lifeline_notext.csv', stringsAsFactors=F, colClasses = "character")

dp3years =  dp %>%
  mutate(year = lubridate::year(date)) %>% 
  filter(year %in% c(2016, 2017, 2018))
head(dp3years)
tail(dp3years)

prop.lifeline = dp3years %>% 
  #total number of tweets per category
  group_by(main_category_prediction, lifeline) %>% 
  summarise(n = n() ) %>% 
  pivot_wider(id_cols = main_category_prediction, names_from = lifeline, values_from = n) %>% 
  rename("lifeline" = '1', "no_lifeline" = "0") %>% 
  mutate(pr = lifeline/(lifeline+no_lifeline))

prop.lifeline
write.csv(prop.lifeline, './results/proportion_tweets_with_lifeline_2016-2018_273-TALK_800273TALK_Lifeline_8255.csv', row.names=F)
