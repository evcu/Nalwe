#!/bin/bash
# Description:  Prepares tar snapshot of nalwe/ folder and generates script to submit to the cluster with the name given (Eg: job1). 
#               After the script (Eg: ./script_local.sh) is executed in the nalwe/ folder. Files in the nalwe/out/ copied to the output folder 
#               provided(Eg: output/vecs/). At the end of the job script the script and tar files are removed from $HOME folder. 
#               Job-id of the job submitted to the queue written to stdout.
# Usage:        ./genJob.sh name_of_job outputfolder path_to_script [duration] 
# Example:      ./genJob.sh job1 output/vecs/ ./script_local.sh 3:00:00

LNS=1:ppn=15  				#-lnodes
LWT=$4
: ${LWT:="5:00:00"} 		#-lwalltimecar default: 5:00:00
FILE_TAR="jobs/$1.tar.gz"
FILE_SH="jobs/$1.sh"
PATH_TAR="\$HOME/$FILE_TAR"
OUT_PATH="\$HOME/$2"
SCRIPT_FILE=$3

tar cf $FILE_TAR ./nalwe/ #No compression, because it is slow.

if [ -e $FILE_SH ]; then
  rm $FILE_SH
fi
  echo "#PBS -lnodes=$LNS">> $FILE_SH
  echo "#PBS -lwalltime=$LWT">> $FILE_SH
  echo "#PBS -S /bin/bash">> $FILE_SH
  echo "cd \$TMPDIR">> $FILE_SH
  echo "tar xf $PATH_TAR>&- || echo \"$1.tar is extracted\"">> $FILE_SH 
  echo "cd nalwe/">> $FILE_SH
  echo "$SCRIPT_FILE">> $FILE_SH
  echo "cp -vr ./out/. $OUT_PATH">> $FILE_SH 
  echo "rm $PATH_TAR \$HOME/$FILE_SH">> $FILE_SH
chmod +x $FILE_SH 
JOBID=$(bash ./local_qsub.sh $FILE_SH)
#LOCAL $(qsub $FILE_SH| cut -d '.' -f 1)
echo $JOBID

exit 0; 
