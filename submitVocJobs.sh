#!/bin/bash

# Description: 	Script for generetaing vocabularies by submitting jobs. Parameter space consists of Min-count and Stpword-removal?
#				Min-count is the minimum number occurences to be in the vocabulary. Stopwords is a binary parameter and can have y or n values.	
#				It is descibed in line 19. The results are copied to the output/vocs/ folder. A corpus file from corpuss/ should be provided as argument.
# Usage: 		./submitVocJobs.sh corpus
# Example:      ./submitVocJobs.sh wiki.txt 
# Note: 		Call the script from the folder it is in.  

if [ $# -ne 1 ]; then
	echo "Please provide the corpus and voc names as arguments"
	exit 1
fi
CORP=$1

# PARAMETER SET #
MINS=(10 30)
STOPWORDS=(n y)  #This can be (n) or (n y) or (y). "n" means training without removing the stopwords. "y" means removing the stopwords.


#CAN CHANGE
CALL_PER_JOB=5 
MAX_TIME_PER_JOB=5:00
#DON'T CHANGE
COUNTER=0
GROUP_NO=0
SCRIPT_START="#!/bin/bash \ncp \$HOME/corpuss/$CORP inp/"
#DON'T NEED TO CHANGE
LOCAL_SCRIPT_NAME=script_local.sh
TEMP_SCRIPT_FILE=nalwe/$LOCAL_SCRIPT_NAME
JOB_GROUP="voc_$RANDOM"   #`date +%N`
LOG_FILE="jobs/logs/$JOB_GROUP"
OUTPUT_FOLDER=output/vocs/${JOB_GROUP}/
STOPWORD_FILE=inp/stopwords.txt #Make sure that provided parameter exists in nalwe/inp/ folder. 

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
echo "MAX_TIME_PER_JOB: $MAX_TIME_PER_JOB">>$LOG_FILE

printf "%-5s%-12s%-12s\n" No Min-Count StopWords>> $LOG_FILE

for m in "${MINS[@]}"
do
for s in "${STOPWORDS[@]}"
do
echo "time ./scripts/createVoc.sh inp/$CORP $m $s $STOPWORD_FILE && echo \"Vocabulary generation no:$COUNTER successfull\" || echo \"Vocabulary generation no:$COUNTER failed\"" >>$TEMP_SCRIPT_FILE
printf "%-5s%-12s%-12s\n" $COUNTER $m $s >> $LOG_FILE
let "COUNTER++"
	if (( $COUNTER % $CALL_PER_JOB == 0 ))           # no need for brackets
	then
		chmod +x $TEMP_SCRIPT_FILE
		./genJob.sh  "$JOB_GROUP"_$GROUP_NO $OUTPUT_FOLDER ./$LOCAL_SCRIPT_NAME $MAX_TIME_PER_JOB >> $LOG_FILE #TODO naming
		rm $TEMP_SCRIPT_FILE
		echo -e $SCRIPT_START >> $TEMP_SCRIPT_FILE
		let "GROUP_NO++"
	fi 
done		
done	


if (( $COUNTER % $CALL_PER_JOB != 0 ))           # no need for brackets
then
	chmod +x $TEMP_SCRIPT_FILE
	./genJob.sh  "$JOB_GROUP"_$GROUP_NO $OUTPUT_FOLDER ./$LOCAL_SCRIPT_NAME $MAX_TIME_PER_JOB >> $LOG_FILE #TODO naming
fi 

echo $JOB_GROUP
exit 0
