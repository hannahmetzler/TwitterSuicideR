# Create dataset with important classess only, and all minority classes combined with irrelevant tweets
library(dplyr)
library(ggplot2)
library(cowplot)

d <- read.csv('./tweet_training_set/training_posts20201126_corrections_true_label_errors.tsv', header=TRUE, sep='\t')

xtabs(~Category, d)

d1 = d %>% 
  #add all minority classes and suicide other and off-topic to one large class called "irrelevant":
  #based on comparison of tweet texts of different categories, news tweets are really different from personal coping or suicidality tweets, 
  #therefore all into irrelevant (this now includes off-topic and suicide_other tweets, to limit classes to 6 for the machine learning model)
  mutate(main_category = recode(Category, news_suicidality = "irrelevant", news_coping = "irrelevant", bereaved_negative = "irrelevant", bereaved_coping = "irrelevant", 
                                life_saved = "irrelevant", suicide_other = "irrelevant", "off-topic" = "irrelevant", 
                                coping1 = "coping", coping3 = "coping", suicidality1 = "suicidality", suicidality3 = "suicidality")) %>% 
  # is a tweet actually about suicide or not?
  mutate(about_suicide = ifelse(Category=="off-topic", 0, 1)) %>%
  #e.g. put Category 2 column after Category column
  dplyr::relocate(main_category, .after=Category2) %>%
  dplyr::relocate(about_suicide, .after=main_category)

names(d1) = tolower(names(d1))

as.data.frame(xtabs(~main_category, d1))

# write.table(d1,'./tweet_training_set/training_posts20201130_main_categories.tsv', sep='\t', row.names=F)
# save(d1, file='./tweet_training_set/training_posts20201130_main_categories.R')


#define the order for categories in plots
ord_category <- c("suicidality1","suicidality3","coping1", "coping3", "news_coping", "news_suicidality", "bereaved_negative", "bereaved_coping","awareness", "prevention",  "werther", "life_saved", "suicide_other","off-topic")
ord_mcategory= c( "suicidality", "coping", "awareness", "prevention", "werther", "irrelevant")

#load newest version of training sample (8 more coping tweets, 5 more suicidality, 9 more bereaved)
d <- read.csv('./tweet_training_set/training_posts20201201_main_categories.tsv', header=TRUE, sep='\t') %>% 
  #order the categories
  mutate(category = factor(category, levels = ord_category, labels = ord_category),
         main_category = factor(main_category, levels = ord_mcategory, labels = ord_mcategory),
         about_suicide = factor(about_suicide, levels = c(0,1), labels = c("no", "yes")),
         notserious_unclear = factor(notserious_unclear, levels = c(0,1), labels = c("no", "yes")))

# Propotions for different categories in the final training data set, stats and figures ####

#Proportion of tweets per subcategory ####
prop.cat = as.data.frame(d %>% 
                group_by(category) %>%
                summarise (n = n()) %>%
                mutate(freq = n / sum(n))) %>%
  ungroup()
prop.cat
#figure subcategories:
s=15
plot.prop.cat<- ggplot(prop.cat, aes(x=category, y = freq, fill=category)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle(paste("Tweets per subcategory in training sample n =", sum(prop.cat$n,2)))+
  labs(y="Proportion", x="") + #axes and title labels
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "#117733", '#999933', '#DDCC77', '#CC6677', "#882255", "#332288", "#88CCEE", "#44AA99", "#AA4499", "#999999",  "#444444"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))
plot.prop.smallcat<- ggplot(subset(prop.cat, freq <0.08), aes(x=category, y = freq, fill=category)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle("Minority classes in training sample > 0.08")+
  labs(y="Proportion", x="") + #axes and title labels
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "#117733", '#999933', '#DDCC77', '#CC6677', "#882255", "#AA4499"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))
plot.n.cat<- ggplot(prop.cat, aes(x=category, y = n, fill=category)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle(paste("Tweets per subcategory in training sample n =", sum(prop.cat$n,2)))+
  labs(y="n tweets", x="") + #axes and title labels
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "#117733", '#999933', '#DDCC77', '#CC6677', "#882255", "#332288", "#88CCEE", "#44AA99", "#AA4499", "#999999",  "#444444"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))
plot.n.smallcat<- ggplot(subset(prop.cat, freq <0.08), aes(x=category, y = n, fill=category)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle("Minority classes in training sample n > 250")+
  labs(y="n tweets", x="") + #axes and title labels
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "#117733", '#999933', '#DDCC77', '#CC6677', "#882255", "#AA4499"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))
pdf("./figures/proportions_subcategories_training_sample.pdf", height=10, width=7)
plot_grid(plot.prop.cat, plot.prop.smallcat, ncol=1)
plot_grid(plot.n.cat, plot.n.smallcat, ncol=1)
dev.off()

#proportion per main category in training sample ####
prop.main <- as.data.frame(d %>%
                             group_by(main_category) %>%
                             summarise (n = n()) %>%
                             mutate(freq = n / sum(n))) %>% 
  ungroup()
# write.table(prop.main,'output/tweets_per_maincategory_finaltrainingsample_20210104.tsv', sep='\t', row.names=F)

#Figure main category in final training sample
plot.prop.main<- ggplot(prop.main, aes(x=main_category, y = freq, fill=main_category)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle(paste("Tweets per main category in training sample n=", sum(prop.main$n,2)))+
  labs(y="Proportion", x="") + #axes and title labels
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "#117733", '#999933', '#DDCC77', '#CC6677', "#882255", "#AA4499"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))
plot.n.main<- ggplot(prop.main, aes(x=main_category, y = n, fill=main_category)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle(paste("Tweets per main category in training sample n=", sum(prop.main$n,2)))+
  labs(y="n tweets", x="") + #axes and title labels
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "#117733", '#999933', '#DDCC77', '#CC6677', "#882255", "#AA4499"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))

plot.prop.main
plot.n.main
pdf('./figures/maincategories_training_sample.pdf', height=5, width=7); plot.prop.main; plot.n.main; dev.off()


#How many tweets are about suicide in training sample? ####

#proportion with combined categories
prop.about <- as.data.frame(d %>%
                             group_by(about_suicide) %>%
                             summarise (n = n()) %>%
                             mutate(freq = n / sum(n))) %>% 
  ungroup()
# write.table(prop.about,'output/tweets_per_aboutsuicide_finaltrainingsample_20210104.tsv', sep='\t', row.names=F)
prop.about 

#Figure Frequency in final training sample
plot.prop.about<- ggplot(prop.about, aes(x=about_suicide, y = freq, fill=about_suicide)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle("Tweet is about actual suicide")+
  labs(y="Proportion", x="") + #axes and title labels
  # scale_fill_brewer(palette="Paired")+
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "117733", '#CC6677', "#882255"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))

plot.prop.about

#How many tweets are not serious, use metaphors or unclear if serious in training sample? ####
prop.serious <- as.data.frame(d %>%
                              group_by(notserious_unclear) %>%
                              summarise (n = n()) %>%
                              mutate(freq = n / sum(n))) %>% 
  ungroup()

plot.prop.serious<- ggplot(prop.serious, aes(x=notserious_unclear, y = freq, fill=notserious_unclear)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle("Tweet is not serious, unclear if serious,\nor uses suicide as metaphor")+
  labs(y="Proportion", x="") + #axes and title labels
  # scale_fill_brewer(palette="Paired")+
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "117733", '#CC6677', "#882255"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))

plot.prop.serious


# Random sample of 1000 tweets ####

#proportion per main category in training sample ####
prop.main <- as.data.frame(d %>%
                             filter(set=="basefrequency") %>% 
                             group_by(main_category) %>%
                             summarise (n = n()) %>%
                             mutate(freq = n / sum(n))) %>% 
  ungroup()
# write.table(prop.main,'output/tweets_per_maincategory_finaltrainingsample_20210104.tsv', sep='\t', row.names=F)

#Figure main category in final training sample
plot.prop.main<- ggplot(prop.main, aes(x=main_category, y = freq, fill=main_category)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle("Tweets per main category in random sample n=1000")+
  labs(y="Proportion", x="") + #axes and title labels
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "#117733", '#999933', '#DDCC77', '#CC6677', "#882255", "#AA4499"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))
plot.n.main<- ggplot(prop.main, aes(x=main_category, y = n, fill=main_category)) + #dataset and variables to plot
  geom_bar(stat="identity")+
  ggtitle("Tweets per main category in random sample n=1000")+
  labs(y="n tweets", x="") + #axes and title labels
  scale_fill_manual(values=c("#332288", "#88CCEE", "#44AA99", "#117733", '#999933', '#DDCC77', '#CC6677', "#882255", "#AA4499"))+
  theme_bw() +  
  theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position="none", text=element_text(size=s))

plot.prop.main
plot.n.main
pdf('./figures/maincategories_random_sample.pdf', height=5, width=7); plot.prop.main; plot.n.main; dev.off()
write.table(prop.main,'output/tweets_per_maincategory_randomsample_20210104.tsv', sep='\t', row.names=F)
