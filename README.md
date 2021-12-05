# TwitterSuicide
Project classifying tweets about suicide into different classes relevant for media effects research for suicide prevention

Our datasets do not include the text of tweets, in order to protect sensitive user data. Either rehydrate the IDs to get tweet, or contact me at metzler@csh.ac.at to get the datasets including tweet text. 

## Folder structure

- scripts: contains R Markdown scripts to run all analyses. When running these, PDF-Reports are created in the same folder. Not all scripts can be run with the data in this repository, but all those for reproducing the analysis in the paper can. See below for which scripts can and can't be run. 
- reliability datasets: contains the datasets with model predictions of the final model and labels for each human rater for n=750 tweets in the reliability dataset. They are called round 4 because reliablity was calculated several times when building the training dataset. See paper section Creation of annotation scheme. 
- results: outputs created by the script, which are then used for further scripts, or used as tables in the paper
- tweet_training_set: contains the final version of the training set without tweet text


Scripts that CAN be run with the datasets available in the repository
- 01a

Scripts that CANNOT be run with the datasets available in the repository
- 01b: for this script, datafiles with tweet text of the training set would be necessary. Script included to provide transparency about the creation of the training set and annotation scheme. 

