#!/bin/bash

# Description:  Demo script to demonstrate the usage of the scripts.
# Usage: 		./demo.sh corpus
# Example:      ./demo.sh wiki.txt =
# Note: 		Call the script from the folder it is in.  

# STEP:1 	Download the corpus and process it with Matt Mahoney's perl script. Be sure that the clean corpus is on `corpuss/` folder.
#			You can submit the downloading and processing job to SurfSara with `corpuss/getWikiCorpusJob.sh` or with `corpuss/getWikiCorpusOnPlace.sh`

CORPUS=wiki100.txt
# STEP:2 	Open the `submitVocJobs.sh` file and set the parameter space by updating PARAMETER SET section in the script. 
#			Change the `CALL_PER_JOB` variable to set how many vocabularies to generate in one job. Since vocabulary generation is fast relative to the training. So you can submit all vocabularies in 1 job. 
#			Change the `MAX_TIME_PER_JOB` variable to set the maximum time. Usually as small as 10 minutes. 
# 			Execute the script by providing the name of the corpus file which is in `corpuss/` folder to the submitVocJobs script. 
#			The results are going to be saved to `output/vocs/`. 

JOB_GROUP_ID=$(./submitVocJobs.sh $CORPUS)

# STEP:3 	Open the `submitw2vJobs.sh` file and set the parameter space by updating PARAMETER SET section in the script.
#			Change the `CALL_PER_JOB` variable to set how many models to train in one job. 
#			Change the `MAX_TIME_PER_JOB` variable to set the maximum time. You can refer to the old results for estimating.
#			Submit the w2v training with the vocabulary file and corrpuss path/name. Vocabulary path is relative to the `output/vocs/` and corpus path is relative to `corpuss\`
#			Code below gets all the vocabulary files trained in the same job and then use them to the training. 
VOCS=( $(ls output/vocs/${JOB_GROUP_ID}/) )

for v in "${VOCS[@]}"
do
	./submitw2vJobs.sh $CORPUS ${JOB_GROUP_ID}/$v
done

#STEP:4

