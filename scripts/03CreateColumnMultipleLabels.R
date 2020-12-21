# 02 Create ambiguous column in training set from 20201103

library(dplyr)
library(stringr)
library(tidyselect)

# #read latest training set version
#d <- read.csv('./tweet_training_set/training_posts20201105_3181tweets.tsv', header=TRUE, sep='\t')
#str(d)
d$Combined = NULL
length(str_subset(d$Contents, "\n")) #no tweets with line separators

#all labels to lower case
levels(d$ambiguous) = tolower(levels(d$ambiguous))
levels(d$Category) = tolower(levels(d$Category))
levels(d$Combined) = tolower(levels(d$Combined))

# levels in ambiguous that contain an existing label of Category need to be copied into a column with the second label of each tweet.
# this is because column ambiguous contains different things, including possible second labels, 
# small unclear category codings that still need to be checked, 
# as well as a note if a tweet is an exxaggeration or a metaphor. 
# We want to only copy those that reflect a possible second label into the Category2 column. 

# Which levels exist?
levels(d$ambiguous)
levels(d$Category) 

# which levels contain a label in addition to other info?
#delete info that is not a category label in the Category2 column
str_subset(d$ambiguous, ',')

#copy all labels that exist in Category from ambiguous to Category2
d1 = d %>% 
  mutate(Category2 = case_when(
    #if label in the  ambiguous exists as a label in Category, this is the 2nd correct label of a tweet
    ambiguous %in% levels(Category) ~ ambiguous,
    #when the category label is not the only info in ambiguous, this info is separated by a comma, therefore detect if there is a comma and then copy to Category2
    str_detect(d$ambiguous, ',') ~ ambiguous),
    Category2 = recode(Category2, 'news_suicidality, suicidality3' = 'suicidality3'))  %>%  #recode the only tweet with 3 category labels to the more important one
  #e.g. put Category 2 column after Category column
  dplyr::relocate(Category2, .after=Category)  
  
  
  
#delete info that is not a category label in the Category2 column, everything up to the comma plus one empty space after
d1$Category2 <- (gsub(".*, ", "",d1$Category2))

#now there are only labels left that also exist in the initial Category column
xtabs(~d1$Category2)

#Check if the correct ones were replaced
length(d1$ambiguous[!is.na(d1$Category2)]) # looks good, 155 double labels

# the original ambiguous column also had 155 labels that were either an existing Category label, or contained a comma (i.e. a category label plus some other info)
nrow(d %>% 
       filter(str_detect(ambiguous, ',') | ambiguous %in% levels(Category)))

# #create a combined column where minority classes are assigned to a larger class
# d2 = d1 %>% 
#   mutate(Combined = recode(Category, coping1 = "coping", coping3 = "coping", suicidality1 = "suicidality", suicidality3 = "suicidality", 
#                            news_coping = "coping", news_suicidality = "suicidality",
#                            life_saved ="suicide_other", bereaved_coping = "suicide_other", bereaved_negative ="suicide_other"), 
#          Combined2 =  recode(Category2, coping1 = "coping", coping3 = "coping", suicidality1 = "suicidality", suicidality3 = "suicidality", 
#                              news_coping = "coping", news_suicidality = "suicidality",
#                              life_saved ="suicide_other", bereaved_coping = "suicide_other", bereaved_negative ="suicide_other"))  %>% 
#   # reorganize column order
#   dplyr::relocate(Combined, .after=Category2) %>% 
#   dplyr::relocate(Combined2, .after=Combined)
# head(d2)

length(str_subset(d1$Contents, "\n"))

#write the data with the new column to a file
write.table(d1,'./tweet_training_set/training_posts20201124_multiple_labels.tsv', sep='\t', row.names=F)
save(d1, file='./tweet_training_set/training_posts20201124_multiple_labels.R')
