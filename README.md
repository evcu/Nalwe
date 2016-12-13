# The importance of normalisation while learning word embeddings 

This code is written by [Utku Evci](https://github.com/evcu/) during the internship at ILPS, UvA in Summer 2016.
The scripts provided aims to facilitate training word2vec and GloVe vectors in SurfSara's Lisa cluster. 
Currently project only includes scripts for _word2vec_ training. However extending it to GloVe requires a little work. 
To be able to submit multiple jobs to the cluster, groupping approach is taken. You provide a corpuss and a vocabulary and a set of training-parameters. Then the script submits multiple-jobs with all different combinations of the parameter-set to the cluster automatically under the name of a *JOB_GROUP* and tracks them.

### Quick Take: _How To Run Project_

The steps needed to be taken for using the code demonstrated in the `./demo.sh`script and summarized below. 

1. __Download project to your home folder__
 * All the folders(`output/`,`nalwe/`,etc.) and files(`genJob.sh`,etc.) of the project should be in $HOME folder of your SurfSara account for proper execution. (TODO: update the code to use git clone directly.)  
2. __Get the corpus__
 * Download wiki-corpus and process it with Matt Mahoney's perl script. Be sure that the clean corpus is on `corpuss/` folder.  
 * You can submit downloading and processing of latest wikipedia-dump job to Lisa with `corpuss/getWikiCorpusJob.sh` or use `corpuss/getWikiCorpusOnPlace.sh` for immidiate execution.  
3. __Generate Vocabularies__ 
 * Open the `submitVocJobs.sh` file and set the parameter space by updating _PARAMETER SET_ section in the script.  
 * Change the `CALL_PER_JOB` variable to set how many vocabularies to generate in one job. Since vocabulary generation is fast relative to the training. So you can submit all vocabularies in 1 job.  
 * Change the `MAX_TIME_PER_JOB` variable to set the maximum time. Usually as small as 10 minutes.  
 * Execute the script by providing the name of the corpus file which is in `corpuss/` folder to the submitVocJobs script.  
 * The results are going to be saved to `output/vocs/`.  
4. __Train Models__
 * Open the `submitw2vJobs.sh` file and set the parameter space by updating _PARAMETER SET_ section in the script.
 * Change the `CALL_PER_JOB` variable to set how many models to train in one job. 
 * Change the `MAX_TIME_PER_JOB` variable to set the maximum time. You can refer to the results of previous trainings(links) to estimate maximum-time.
 * Submit the w2v training with the vocabulary file and corrpuss path. Vocabulary path is relative to the `output/vocs/` and corpus path is relative to `corpuss\`
 * The results are going to be saved to `output/vecs/`
 * The training results are printed into standard output of Lisa and they are saved to the _$HOME_ folder when the job is finished. 

5. __Process Output__
 * A next direction for the project includes presenting the evaluation of models in an online javascript page. Therefore the project includes an after-processing script, which combines the log files, which includes the hyper-parameter set-up of each model and the results of the evaluation and training, into an _JSON_ array.
 * You just need to execute the script at _$HOME_ folder `pp_`*JOBGROUP*`.sh`and the resulting JSON file is going to be saved in the same folder as the resulting vectors: i.e. `/output/vecs/_JOBGROUP_/`. If the JSON generation is succesfull, then the logs and the job-output files are removed.

### Details 

Code has the following organization 

Folder 	| Description
-		|-
corpuss	|Various common corpara are downloaded into this directory. There are two scripts for downloading wiki-corpus and Matt Mahoney's perl script to process it.
jobs	|Includes the scripts and tar-archive of submitted jobs. `logs/` folder includes the hyperparamater information of submitted job-groups.
nalwe	|Includes the various scripts for training and evoluation along with the c-code of word2vec and GloVe. 
output 	|Contains the vocabulary and vector outputs. `vocs/` for Vocabulary files. `vecs/` for trained word embeddings. `cooc/` is for Coocurence files used by GloVe algorithm.
oldScripts | Scripts used for corpus download.

Script 	| Description 	| Usage
- 		| -				| -
`./genJob.sh`	|Prepares tar snapshot of `nalwe/` folder and generates script to submit to the cluster with the name given (_Eg: job1_). After the script (*./script_local*) is executed in the `nalwe/` folder ,files in the `nalwe/out/` copied to the output folder provided(*output_vecs/*)  |`./genJob.sh job1 output/vecs/ ./script_local 3:00:00`
