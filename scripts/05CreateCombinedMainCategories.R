# Create dataset with important classess only, and all minority classes combined with Irrelevant tweets

d <- read.csv('./tweet_training_set/training_posts20201126_corrections_true_label_errors.tsv', header=TRUE, sep='\t')

xtabs(~ambiguous, d)

d = d %>% 
  #add all minority classes and suicide other and off-topic to one large class called "irrelevant"
  mutate(main_category = recode(Category, news_suicidality = "irrelevant", news_coping = "irrelevant", bereaved_negative = "irrelevant", bereaved_coping = "irrelevant", 
                                life_saved = "irrelevant", suicide_other = "irrelevant", "off-topic" = "irrelevant", 
                                coping1 = "coping", coping3 = "coping", suicidality1 = "suicidality", suicidality3 = "suicidality")) %>% 
  # is a tweet actually about suicide or not?
  mutate(about_suicide = ifelse(Category=="off-topic", 0, 1)) %>%
  #e.g. put Category 2 column after Category column
  dplyr::relocate(main_category, .after=Category2) %>%
  dplyr::relocate(about_suicide, .after=main_category)

names(d) = tolower(names(d))

xtabs(~main_category, d)

write.table(d,'./tweet_training_set/training_posts20201130_main_categories.tsv', sep='\t', row.names=F)
save(d, file='./tweet_training_set/training_posts20201130_main_categories.R')