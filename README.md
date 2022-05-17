# TwitterSuicideR
Project classifying tweets about suicide into different classes relevant for media effects research for suicide prevention

The datasets in this repository do not include the text of tweets, in order to protect sensitive user data. If your require the text of tweets, there are 2 options:  

Option a: Rehydrate the IDs via the Twitter API to get all tweets that have not been deleted by their authors in the mean time. This is clearly the preferred option, and aligns with the Twitter Developer Agreement. 

Option b: We will only share data incuding tweet texts under specific conditions: We share the dataset with non-profit organizations, and for projects that clearly benefit the data subjects or have a clear scientific purpose that advances the common interest. In this case, you can contact me at metzler@csh.ac.at to get the datasets including tweet text. Please explain your use case in detail to help us make a decision. 


All code for training the machine learning models is available at: https://github.com/HubertBaginski/TwitterSuicideML. 

### Folder structure

- scripts: contains R Markdown scripts to run all analyses. When running these, PDF-Reports are created in the same folder. Not all scripts can be run with the data in this repository, but all those for reproducing the analysis in the paper can. See below for which scripts can and can't be run. 
- reliability datasets: contains the datasets with model predictions of the final model and labels for each human rater for n=750 tweets in the reliability dataset. They are called round 4 because reliablity was calculated several times when building the training dataset. See paper section Creation of annotation scheme. 
- results: outputs created by the script, which are then used for further scripts, or used as tables in the paper
- tweet_training_set: contains the final version of the training set without tweet text
- data_tweet_volumes: daily volumes of tweets per category
- in addition to these folders, you need to add a folder with the name: "full_tweet_set_for_predictions_withRTs_inquery" after cloning this repository. It is the folder for predictions dataset with 14 million tweets (7.15 in the years 2016-2018) for which we predicted labels using BERT. It contains no tweet text, but tweet id's, date, number of retweets of the original tweet, if the tweet is a retweet or not, and whether it contains the lifeline number or a search term referring to the lifeline. It was too large to upload to github, and can be downloaded at: www.doi.org/10.17605/OSF.IO/9WX7V.

### Dataset documentation

**Training data set** (training_posts20201201_main_categories_no_tweet_text.tsv)

- timestamp: publication date and time of the tweet
- tweet_id: ID needed to redownload the tweet via the Twitter API (rehydration)
- set: the subset of the dataset as described in the Manuscript, section "Creating the Annotation Scheme and Labelled Dataset":
    1. inital_training_set_coded_on_CH denotes the about 550 tweets coded on the Crimson Hexagon platform in step 1 of dataset creation. 
    2. reliability_testing_set1 denotes the 500 tweets added in step 2. 
    3. realibility_testing_set2 deontes the remaining tweets added in step 3, until we reached at least 200 per category
    4.   basefrequency denotes the 1000 randomly selected tweets that were added to the training set in step 4
- ambiguous: keywords for tweets the coders found ambiguous at some point during the coding process. E.g. pastsuicidality denotes tweets that speak about suicidality in the past, and implicitly suggest that coping occured, without being explicit.
- notserious_unclear: tweets that are clearly not serious (jokes, metaphors, exaggerations etc) or where it is unclear if they are serious in contrast to sarcastic etc, are marked with a 1. All other tweets get a 0. 
- focus: the problem/suffering vs. solution/coping perspective of the tweet: 0= neither problem solution,1 = problem, 2=solution (see Table 1 in the Manuscript)
- type: denotes the message type (see Table 1 in the Manuscript)
- category: the 12 detailed categories resulting from crossing focus/perspective and type
- category2: an alternative 2nd category that would also fit that was considered during labelling (could be used for multi-label machine learning models). Most tweets do not have a second fitting category. 
- main_category: the 6 categories that models were trained on in the paper (coping, suicidality (=suicidal ideation & attempts), prevention, awareness, werther (=suicide cases) and all other categories combined irrelevant
- about_suicide: tweet is about actual suicide = 1, not about actual suicide = 0. All tweets except the off-topic category are about actual suicide. 


**Number of tweets per category in the dataset**



| Detailed category | n | Main category | About suicide | 
| --- |---|---|--- |
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
- 04 the confusion matrices can be reproduced, but text of tweets cannot be looked at, with the datasets in this repository
- 05
- 06 creates daily proportion per main category and about suicide, from full dataset with individual tweet ids and predictions
- 09 evertything involving volumes, until line 385 can be reproduced. For everything in the section "# Idenfication of peaks and associated events" the raw text of tweets would be needed. 
- 10
- 11
- 12b: calculates proportion of tweets that contain the lifeline number, result for the follow up paper Niederkrotenthaler et al. (submitted)
- 13 (although the paper eventually does not have these bootstrapped CIs, but binomial CIs, because bootstrapp not possible because we did not save predicted labels for all 5 model runs for bert/xlnet)

### Scripts that CANNOT be run with the datasets available in the repository (posted for maximal transparency)
- 01b: for this script, datafiles with tweet text of the training set would be necessary. Script included to provide transparency about the creation of the training set and annotation scheme. 
- 02 and 03: needs early versions/subparts of the training set, scripts that were used during construction of the training dataset
- 08: checks on an earlier version of the predictions dataset. We do not upload this to avoid confusion with the new version. The parallel script for the new dataset is 09. These datasets are available upon request. 
- 12a: checks all tweet text for presence of the lifeline number or name, result for the follow up paper Niederkrotenthaler et al. (submitted)

### Results folder: 

- The following datasets are NOT results that can be produced with code in this repository, but with the machine learning code by Hubert Baginski: 
    - predictions_* data sets are predictions produced by the models at github.com/HubertBaginski/TwitterSuicideML.
    - BERT2, XLNEt performance datasets contain results of the model training scripts at github.com/HubertBaginski/TwitterSuicideML.

- Tables for Paper formatted.xlsx was created manually. It is a collection of all tables that can be found in the manuscript and supplementary information. Results from machine learning code and scripts in this repository are combined. 

The following datafiles are outputs of scripts in this repository: 
- Table4_... scores for ML with CIs 6 classes main category, in the correct shape for the table
- Table6_... scores for ML with CIs 2 classes about suicide, in the correct shape for the table
- intraclass_performance*.Rdata files: scores for ML with CIs for all models, useful for use within R


