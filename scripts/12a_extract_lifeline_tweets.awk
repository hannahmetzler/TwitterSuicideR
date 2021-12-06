#Goal: in the file twitter_14M_with_predictions_withRTs.csv, add a column with 1 and 0 for every tweet that contains the lifeline number

#careful with the file:  TwitterSuicideR/full_tweet_set_for_predictions_withRTs_inquery/twitter_14M_with_predictions_withRTs.csv
# it does not have the 5th field separated properly, so awk does not treat it correctly, something wrong with line endings (written in python by Hubert), but it works in R/Python
#use instead for awk: TwitterSuicideR/full_tweet_set_for_predictions_withRTs_inquery/suicide_tweets_with_RT.tsv

#Use script in bash terminal

#print only tweet text from the csv to a text file: third field with awk: 
awk -F'\t' '{print $3}' suicide_tweets_with_RT.tsv > tweet_text

#extract 500 tweets to the file test for developing the script
#head tweet_text -n 20000 |tail -n 10000 > test

#second step: filter for the number of the lifeline in each line (one line contains it in the first 500 tweets)
awk '/800-273-8255/{print $0} test

#if all fields $0 (only text in file) contains the number or any other search term, print 1, otherwise 0
awk '{if ($0 ~ /800273TALK|800.273.TALK|Lifeline|8255/) {print "1"} else {print "0"}}' tweet_text > lifeline

#captures all of these terms: 
1-800-273-TALK
800-273-TALK
800 273 TALK
800273TALK
Lifeline
Suicide Prevention Lifeline
(800) 273-8255
800-273-8255
1-800-273-8255
1 800 273 8255

#show tweets with only 8255
awk '/8255/{print $0}' test > testtext # print the tweets with the number to testtext

