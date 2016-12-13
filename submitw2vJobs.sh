#!/bin/bash

# Description: 	Main script for generating multiple word2vec training jobs. #PARAMATER SET# below contains the decleration of the input space.
#				For each combination of the provided variables in the parameter set a word embedding is trained. 
#				A job_group-id is randomly generated for each call of this script. Multiple training calls(Eg: $CALL_PER_JOB) grouped under one job.
#				The naming of the job created from the job_group-id and group-no. For each group one tar file and local_script created. 
#				Each script starts with copying the corpus and vocabulary to the inp folder and each training uses this common files. 
#				One log file is generated under jobs/logs/ folder under the name of job_group-id.
#				Corpus name from `corpuss/` folder and vocabulary name from `output/vocs/` should provided as first two arguments. 
# Usage: 		./submitw2vJobs.sh corpus vocabulary
# Example:      ./submitw2vJobs.sh wiki.txt voc
# Note: 		Call the script from the folder it is in.  

if [ $# -ne 2 ]; then
	echo "Please provide the corpus and voc names as arguments"
	exit 1
fi

CORP=$1
#VOC_FILES=(`ls nalwe/inp/voc* | sed 's:^nalwe/::'`) #Gets all the files starting with voc from nalwe/inp/ folder.
VOC_FILE=$2

# PARAMETER SET #
W_SIZES=(5 10)
DIMENSIONS=(100)
NEG_SAMPLES=(5 10)
SUB_SAMPLES=(1e-4)   	#1e-4
ALPHAS=(0.025)		#0.025
ITERS=(5)		#15

#CAN CHANGE
CALL_PER_JOB=2
MAX_TIME_PER_JOB=4:00

#DON'T CHANGE
COUNTER=0
GROUP_NO=0
SCRIPT_START="#!/bin/bash \ncp \$HOME/corpuss/$CORP inp/corp \ncp \$HOME/output/vocs/$VOC_FILE inp/voc"

#DON'T NEED TO CHANGE
LOCAL_SCRIPT_NAME=script_local.sh
TEMP_SCRIPT_FILE=nalwe/$LOCAL_SCRIPT_NAME
JOB_GROUP="w2v_$RANDOM" 
LOG_FILE="jobs/logs/$JOB_GROUP"
OUTPUT_FOLDER=output/vecs/${JOB_GROUP}/
AFTER_JOB_SCRIPT="pp_${JOB_GROUP}.sh"

if [ -e $TEMP_SCRIPT_FILE ]; then
  rm $TEMP_SCRIPT_FILE
fi
echo  -e $SCRIPT_START >> $TEMP_SCRIPT_FILE

if [[ -e $OUTPUT_FOLDER || -e $LOG_FILE ]]; then
  echo "The job-group-id $JOB_GROUP already exists. Your random numbers sucks. You can delete previous logs and outputs to not get the error again, or change naming convention."
  exit 1
fi

mkdir $OUTPUT_FOLDER
echo "CALL_PER_JOB: $CALL_PER_JOB">$LOG_FILE
echo "CORP: $CORP">>$LOG_FILE
echo "VOC_FILE: $VOC_FILE">>$LOG_FILE
echo "MAX_TIME_PER_JOB: $MAX_TIME_PER_JOB">>$LOG_FILE
printf "%-5s%-12s%-12s%-20s%-16s%-16s%-16s\n" No Window_Size Vector_Dim Negative_Samples Sub_Sampling Starting_Alpha Total_Iteration>> $LOG_FILE

for a in "${ALPHAS[@]}" 			#It is ordered such that must influancial ones are lower. So we have a more uniform total training time per job.
do
for s in "${SUB_SAMPLES[@]}"
do
for n in "${NEG_SAMPLES[@]}"
do
for w in "${W_SIZES[@]}"
do
for d in "${DIMENSIONS[@]}"
do
for i in "${ITERS[@]}"
do
echo "time ./scripts/w2vTrain.sh inp/corp inp/voc $w $d $n $s $a $i && echo \"W2V training no:$COUNTER successfull\" || echo \"W2V training no:$COUNTER failed\"" >>$TEMP_SCRIPT_FILE
printf "%-5s%-12s%-12s%-20s%-16s%-16s%-16s\n" $COUNTER $w $d $n $s $a $i >> $LOG_FILE
let "COUNTER++"
	if (( $COUNTER % $CALL_PER_JOB == 0 ))           # no need for brackets
	then
		chmod +x $TEMP_SCRIPT_FILE
		./genJob.sh  "$JOB_GROUP"_$GROUP_NO $OUTPUT_FOLDER ./$LOCAL_SCRIPT_NAME $MAX_TIME_PER_JOB >> $LOG_FILE 
		rm $TEMP_SCRIPT_FILE
		echo -e $SCRIPT_START >> $TEMP_SCRIPT_FILE
		let "GROUP_NO++"
	fi 
done		
done	
done	
done	
done	
done	


if (( $COUNTER % $CALL_PER_JOB != 0 ))           # no need for brackets
then
	chmod +x $TEMP_SCRIPT_FILE
	./genJob.sh  "$JOB_GROUP"_$GROUP_NO $OUTPUT_FOLDER ./$LOCAL_SCRIPT_NAME $MAX_TIME_PER_JOB >> $LOG_FILE 
fi 

echo "#!/bin/bash">$AFTER_JOB_SCRIPT
echo "python processOutput.py $JOBGROUP>$OUTPUT_FOLDERres.json>$AFTER_JOB_SCRIPT && rm $JOBGROUP* $LOG_FILE \$0 || rm $AFTER_JOB_SCRIPT">>$AFTER_JOB_SCRIPT
chmod +x $AFTER_JOB_SCRIPT

exit 0