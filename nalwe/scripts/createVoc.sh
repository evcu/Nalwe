#!/bin/bash

# Description: 	Script for generetaing vocabularies by submitting jobs. Parameter space consists of Min-count and Stpword-removal?
#				Min-count is the minimum number occurences to be in the vocabulary. Stopwords is a binary parameter and can have y or n values.	
#				It is descibed in line 19. The results are copied to the output/vocs/ folder. A corpus file from corpuss/ should be provided as argument.
# Usage: 		scripts/createVoc.sh corpus min-count stopwords{y,n}
# Example:      /scripts/createVoc.sh inp/wiki.txt 10 y
# Note: 		Call the script from the folder nalwe/

CORPUS=$1
VC_PATH="gv/build/vocab_count"
VOCAB_MIN_COUNT=$2
SW=$3
SW_FILE=$4
VERBOSE=1
VOCAB_FILE="out/voc-${VOCAB_MIN_COUNT}_$SW"

if [ $SW = n ]
  then
	$VC_PATH -min-count $VOCAB_MIN_COUNT -verbose $VERBOSE < $CORPUS > $VOCAB_FILE
	exit 0
elif [ $SW = y ]
	then
    echo "Stop-words are going to be removed"
    $VC_PATH -min-count $VOCAB_MIN_COUNT -stopwords $SW_FILE -verbose $VERBOSE < $CORPUS > $VOCAB_FILE
    exit 0
else
  echo "Error: third argument can be either \"y\" or \"n\""
  exit 1
fi



  

