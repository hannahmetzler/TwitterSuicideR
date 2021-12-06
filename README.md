# TwitterSuicideR
Project classifying tweets about suicide into different classes relevant for media effects research for suicide prevention

Our datasets do not include the text of tweets, in order to protect sensitive user data. Either rehydrate the IDs to get tweet, or contact me at metzler@csh.ac.at to get the datasets including tweet text. 

All code for training the machine learning models is available at: https://github.com/HubertBaginski/TwitterSuicideML. 

### Folder structure

- scripts: contains R Markdown scripts to run all analyses. When running these, PDF-Reports are created in the same folder. Not all scripts can be run with the data in this repository, but all those for reproducing the analysis in the paper can. See below for which scripts can and can't be run. 
- reliability datasets: contains the datasets with model predictions of the final model and labels for each human rater for n=750 tweets in the reliability dataset. They are called round 4 because reliablity was calculated several times when building the training dataset. See paper section Creation of annotation scheme. 
- results: outputs created by the script, which are then used for further scripts, or used as tables in the paper
- tweet_training_set: contains the final version of the training set without tweet text
- data_tweet_volumes: daily volumes of tweets per category
- in addition to these folders, you need to add a folder with the name: "full_tweet_set_for_predictions_withRTs_inquery" after cloning this repository. It is the folder for predictions dataset with 14 million tweets (7.15 in the years 2016-2018) for which we predicted labels using BERT. It contains no tweet text, but tweet id's, date, number of retweets of the original tweet, if the tweet is a retweet or not, and whether it contains the lifeline number or a search term referring to the lifeline. It was too large to upload to github, and can be downloaded at: www.doi.org/10.17605/OSF.IO/9WX7V. 


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


