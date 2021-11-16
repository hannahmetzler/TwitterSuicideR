
library(dplyr)
library(caret)

# data from Hubert's excel file, sheet AboutSuicide/Not column J ####

#about suicide, Bert unbalanced, recommended settings, 3e-5, 5 ####

labels <- c("aboutsuicide", "notsuicide")
truth <- factor(rep(labels, times = c(455+22, 58+90)),
                levels = (labels))
pred <- factor( c(rep(labels, times = c(455, 22)),
                  rep(labels, times = c(58, 90))),               
                levels = (labels))
xtab <- table(pred, truth)
#this fits Hubert's stats here: https://imgur.com/AwBYNoS
#Accuracy = average accuracy across both classes
#the other metrics (in last paragraph) are for the positive class
#positive pred value = precision
#sensitivity = recall

average = caret::confusionMatrix(xtab, positive = "notsuicide")$overall[c("Accuracy", "AccuracyLower", "AccuracyUpper")]
  byclass = round(data.frame(
  aboutsuicide = caret::confusionMatrix(xtab, positive = "aboutsuicide")$byClass[c("Precision", "Recall", "F1")],
  notsuicide = caret::confusionMatrix(xtab, positive = "notsuicide")$byClass[c("Precision", "Recall", "F1")]), 2)
write.csv(file = "output/ML_byclass_performance.csv", t(byclass))

#about suicide,BERT unbalanced (1e-5, 10,1) ####
labels <- c("aboutsuicide", "notsuicide")
truth <- factor(rep(labels, times = c(452+25, 49+99)),
                levels = (labels))
pred <- factor( c(rep(labels, times = c(452, 25)),
                  rep(labels, times = c(49, 99))),               
  levels = (labels))
xtab <- table(pred, truth)
average = caret::confusionMatrix(xtab, positive = "notsuicide")$overall[c("Accuracy", "AccuracyLower", "AccuracyUpper")]
byclass = round(data.frame(
  aboutsuicide = caret::confusionMatrix(xtab, positive = "aboutsuicide")$byClass[c("Precision", "Recall", "F1")],
  notsuicide = caret::confusionMatrix(xtab, positive = "notsuicide")$byClass[c("Precision", "Recall", "F1")]), 2)
# write.csv(file = "output/ML_byclass_performance_about_suicide.csv", t(byclass))

# XLNET ####
labels <- c("aboutsuicide", "notsuicide")
truth <- factor(rep(labels, times = c(448+29,46+102)),
                levels = (labels))
pred <- factor( c(rep(labels, times = c(448,	29)),
                  rep(labels, times = c(46,	102))),               
                levels = (labels))
xtab <- table(pred, truth)
average = caret::confusionMatrix(xtab, positive = "notsuicide")$overall[c("Accuracy", "AccuracyLower", "AccuracyUpper")]
byclass = round(data.frame(
  aboutsuicide = caret::confusionMatrix(xtab, positive = "aboutsuicide")$byClass[c("Precision", "Recall", "F1")],
  notsuicide = caret::confusionMatrix(xtab, positive = "notsuicide")$byClass[c("Precision", "Recall", "F1")]), 2)
# write.csv(file = "output/ML_byclass_performance_about_suicide.csv", t(byclass))

# TFIDF ####
labels <- c("aboutsuicide", "notsuicide")
truth <- factor(rep(labels, times = c(417+60,60+88)),
                levels = (labels))
pred <- factor( c(rep(labels, times = c(417,60)),
                  rep(labels, times = c(60,88))),               
                levels = (labels))
xtab <- table(pred, truth)
average = caret::confusionMatrix(xtab, positive = "notsuicide")$overall[c("Accuracy", "AccuracyLower", "AccuracyUpper")]
byclass = round(data.frame(
  aboutsuicide = caret::confusionMatrix(xtab, positive = "aboutsuicide")$byClass[c("Precision", "Recall", "F1")],
  notsuicide = caret::confusionMatrix(xtab, positive = "notsuicide")$byClass[c("Precision", "Recall", "F1")]), 2)
# write.csv(file = "output/ML_byclass_performance_about_suicide.csv", t(byclass))

