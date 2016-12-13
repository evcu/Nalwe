#!/bin/bash

# Description: 	Trains the word embeddings of the `VOCAB_FILE` from the `CORPUS` with the given parameters. 
# Usage: 		scripts/w2vTrain.sh $corpus $vocabfile $windowsize $vec_size $neg_sampling(k) $sub_sampling $starting_alpha $totaliterationovercorpus
# Example:      scripts/w2vTrain.sh TODO
# Note: 		Call the script from the `nalwe/` folder. 
 

CORPUS=$1
VOCAB_FILE=$2
WINDOW_SIZE=$3
VECTOR_SIZE=$4
NEG_SAMP=$5
SUB_SAMP=$6		#1e-4
ALPHA_START=$7	#0.025
CORP_ITER=$8   	#15

NUM_THREADS=32  #32 is a good value for a machine of 16 cores.

W2V_PATH="w2v/word2vec"
EVAL_PATH="scripts/evaluate.py"
VERBOSE=1
OUT_FILE="out/vec-${WINDOW_SIZE}-${VECTOR_SIZE}-${NEG_SAMP}-${SUB_SAMP}-${ALPHA_START}-${CORP_ITER}"

$W2V_PATH -train $CORPUS -output $OUT_FILE -cbow 0 -debug $VERBOSE \
-size $VECTOR_SIZE -window $WINDOW_SIZE -negative $NEG_SAMP -alpha  $ALPHA_START -sample $SUB_SAMP \
-threads $NUM_THREADS -iter $CORP_ITER -read-vocab $VOCAB_FILE -binary 0

 python $EVAL_PATH --vocab_file  $VOCAB_FILE --vectors_file  $OUT_FILE


  

