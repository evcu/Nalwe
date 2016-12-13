#!/bin/bash
 
## define an array ##
VEC_SIZES=(10 100)
WINDOW_SIZE=(4 6 8)

GV_DIR=gv/build
CORPUS=xaa
VOCAB_FILE=gv.Voc.txt
STOPWORD_FILE=stopwords.txt;

VERBOSE=2
VOCAB_MIN_COUNT=3

if [ ! -e $VOCAB_FILE ] ; then
  $GV_DIR/vocab_count -min-count $VOCAB_MIN_COUNT -stopwords $STOPWORD_FILE -verbose $VERBOSE < $CORPUS > $VOCAB_FILE
fi


for n in "${WINDOW_SIZE[@]}"
do
 for m in "${VEC_SIZES[@]}"
  do
	  export CORPUS VOCAB_FILE VERBOSE GV_DIR
	  scr/train.sh $m $n
  done
done
  
  

