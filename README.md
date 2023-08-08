# TwitterSuicideR
Project classifying tweets about suicide into different classes relevant for media effects research for suicide prevention

The datasets in this repository do not include the text of tweets in order to protect sensitive user data. If you require the text of tweets, rehydrate the IDs via the Twitter API to get all tweets that have not been deleted or set to private by their authors in the meantime. Alternatively, you can put together a similar dataset using our ML models from Huggingface to classify new tweets, and then check  the labels manually to see if they fit the categories in our annotation scheme (see the supplementary information). 

All code for training the machine learning models is available at: https://github.com/HubertBaginski/TwitterSuicideML. 

### Machine Learning Models

The BERT machine learning models are available on Huggingface: 
1) Task 1 classifier - 6 main categories (coping, suicidal ideation & attempts, prevention, awareness, suicide case reports, and irrelevant (all other tweets)): https://huggingface.co/HubertBaginski/bert-twitter-main-categories
2) Task 2 classifier: Is a tweet about actual suicide or off-topic (including, for example, sarcastic uses, metaphors, band names etc.): https://huggingface.co/HubertBaginski/bert-twitter-about-suicide

### Folder structure

- scripts: contains R Markdown scripts to run all analyses. When running these, PDF-Reports are created in the same folder. Not all scripts can be run with the data in this repository, but all those for reproducing the analysis in the paper can. See below for which scripts can and can't be run. 
- reliability datasets: contains the datasets with model predictions of the final model and labels for each human rater for n=750 tweets in the reliability dataset. They are called round 4 because reliability was calculated several times when building the training dataset. See paper section Creation of annotation scheme. 
- results: outputs created by the script, which are then used for further scripts or used as tables in the paper
- tweet_training_set: contains the final version of the training set without tweet text
- data_tweet_volumes: daily volumes of tweets per category
- in addition to these folders, you need to add a folder with the name: "full_tweet_set_for_predictions_withRTs_inquery" after cloning this repository. It is the folder for the predictions dataset with 14 million tweets (7.15 in the years 2016-2018) for which we predicted labels using BERT. It contains no tweet text, but the tweet id's, date, the number of retweets of the original tweet, if the tweet is a retweet or not, and whether it contains the lifeline number or a search term referring to the lifeline. It was too large to upload to GitHub, and can be downloaded at: www.doi.org/10.17605/OSF.IO/9WX7V.

### Dataset documentation

**Training data set** (training_posts20201201_main_categories_no_tweet_text.tsv)

- timestamp: publication date and time of the tweet
- tweet_id: ID needed to redownload the tweet via the Twitter API (rehydration)
- set: the subset of the dataset as described in the Manuscript, section "Creating the Annotation Scheme and Labelled Dataset":
    1. inital_training_set_coded_on_CH denotes the about 550 tweets coded on the Crimson Hexagon platform in step 1 of dataset creation. 
    2. reliability_testing_set1 denotes the 500 tweets added in step 2. 
    3. realibility_testing_set2 denotes the remaining tweets added in step 3, until we reached at least 200 per category
    4.   basefrequency denotes the 1000 randomly selected tweets that were added to the training set in step 4
- ambiguous: keywords for tweets the coders found ambiguous at some point during the coding process. E.g. pastsuicidality denotes tweets that speak about suicidality in the past and implicitly suggest that coping occurred, without being explicit.
- notserious_unclear: tweets that are clearly not serious (jokes, metaphors, exaggerations etc) or where it is unclear if they are serious in contrast to sarcastic etc, are marked with a 1. All other tweets get a 0. 
- focus: the problem/suffering vs. solution/coping perspective of the tweet: 0= neither problem solution,1 = problem, 2=solution (see Table 1 in the Manuscript)
- type: denotes the message type (see Table 1 in the Manuscript)
- category: the 12 detailed categories resulting from crossing focus/perspective and type
- category2: an alternative 2nd category that would also fit that was considered during labeling (could be used for multi-label machine learning models). Most tweets do not have a second fitting category. 
- main_category: the 6 categories that models were trained on in the paper (coping, suicidality (=suicidal ideation & attempts), prevention, awareness, werther (=suicide case reports), and all other categories combined as suicide other
- about_suicide: tweet is about actual suicide = 1, not about actual suicide = 0. All tweets except the off-topic category are about actual suicide. 


**Number of tweets per category in the dataset**



| Detailed category | n | Main category | About suicide | 
| --- |---|---|---|
| Suicidal ideation & attempts | 284 | Suicidal ideation & attempts| 1 |
| Coping  | 205 | Coping | 1 |
| Awareness  | 314 | Awareness |1 |
| Prevention  | 457 | Prevention |1 |
| Suicide case | 514 | Suicide case |1 |
| News suicidal ideation  | 68 | Irrelevant |1 |
| News coping  | 27 | Irrelevant |1 |
| Bereaved negative | 34 | Irrelevant |1 |
| Bereaved coping | 34 | Irrelevant |1 |
| Live saved | 13 | Irrelevant |1 |
| Suicide other | 440 | Irrelevant |1 |
| Off-topic | 812 | Irrelevant |0|



### Scripts that CAN be run with the datasets available in the repository
- 01a
- 04 The confusion matrices can be reproduced, but the text of tweets cannot be looked at, with the datasets in this repository
- 05
- 06 Creates the daily proportion per main category and about suicide from the full dataset with individual tweet ids and predictions
- 09 Everything involving volumes until line 385 can be reproduced. For everything in the section "# Idenfication of peaks and associated events" the raw text of tweets would be needed. 
- 10
- 11
- 12b: calculates the proportion of tweets that contain the lifeline number, result for the follow-up paper Niederkrotenthaler et al. (submitted)
- 13 (although the paper eventually does not have these bootstrapped CIs, but binomial CIs. Bootstrapping was not possible because we did not save predicted labels for all 5 model runs for bert/xlnet.

### Scripts that CANNOT be run with the datasets available in the repository (posted for maximal transparency)
- 01b: for this script, data files with tweet text of the training set would be necessary. Script included to provide transparency about the creation of the training set and annotation scheme. 
- 02 and 03: needs early versions/subparts of the training set, scripts that were used during construction of the training dataset
- 08: checks on an earlier version of the predictions dataset. We do not upload this to avoid confusion with the new version. The parallel script for the new dataset is 09. 
- 12a: checks all tweet text for the presence of the lifeline number or name, result for the follow-up paper Niederkrotenthaler et al. (submitted)

### Results folder: 

- The following datasets are NOT results that can be produced with code in this repository, but with the machine learning code by Hubert Baginski: 
    - predictions_* data sets are predictions produced by the models at github.com/HubertBaginski/TwitterSuicideML.
    - BERT2, XLNEt performance datasets contain results of the model training scripts at github.com/HubertBaginski/TwitterSuicideML.

- Tables for Paper formatted.xlsx was created manually. It is a collection of all tables that can be found in the manuscript and supplementary information. Results from machine learning code and scripts in this repository are combined. 

The following data files are outputs of scripts in this repository: 
- Table4_... scores for ML with CIs 6 classes main category, in the correct shape for the table
- Table6_... scores for ML with CIs 2 classes about suicide, in the correct shape for the table
- intraclass_performance*.Rdata files: scores for ML with CIs for all models, useful for use within R


