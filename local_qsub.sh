#!/bin/bash
#
# Description: 	To debug the job_submitting in an offline setting. This script implements `qsub` function of SurfSara: Lisa. 
# Usage: 		qsub script_name
# Example:      qsub TODO
# Note: 		Call the script from the folder it is in.  

JOBID=$RANDOM
cp $1 localLisa/job.sh >&-
HOME=/Users/evcu/Documents/NaLWE 
TMPDIR=/Users/evcu/Documents/NaLWE/localLisa/tmp
export HOME TMPDIR
localLisa/job.sh > o.${JOBID}.txt 2> e.${JOBID}.txt
echo $JOBID
rm -rf localLisa/job.sh localLisa/tmp/*
