VECTOR_SIZE=$1
WINDOW_SIZE=$2

COOCCURRENCE_SHUF_FILE="CoOcr/gv.C-$WINDOW_SIZE" #Cooccurance is recalculated for every different window size
OUT_DIR=outVecs/
GV_VEC_FILE="${OUT_DIR}gv.Vec($VECTOR_SIZE-$WINDOW_SIZE)"
W2V_VEC_FILE="${OUT_DIR}w2v.Vec($VECTOR_SIZE-$WINDOW_SIZE)"

W2V_DIR=w2v
MAX_ITER=15
BINARY=0
NUM_THREADS=32
X_MAX=10

ISEVAL=false

if [ ! -e $COOCCURRENCE_SHUF_FILE ]; then # don't calculate if you already did that!
  export CORPUS VOCAB_FILE COOCCURRENCE_SHUF_FILE VERBOSE WINDOW_SIZE GV_DIR
  scr/gvpre.sh 
fi

echo "Starting w2v for $@"
time $W2V_DIR/word2vec -train $CORPUS -output $W2V_VEC_FILE -cbow 0 \
-size $VECTOR_SIZE -window $WINDOW_SIZE -negative 25 -hs 0 -sample 1e-4 \
-threads $NUM_THREADS -binary $BINARY -iter 15 -read-vocab $VOCAB_FILE
echo "Finishing w2v for $@"
echo "Starting GloVe for $@"
time $GV_DIR/glove -save-file $GV_VEC_FILE -threads $NUM_THREADS \
-input-file $COOCCURRENCE_SHUF_FILE -x-max $X_MAX -iter $MAX_ITER \
-vector-size $VECTOR_SIZE -binary $BINARY -vocab-file $VOCAB_FILE \
-verbose $VERBOSE
echo "Finishing GloVe for $@"

if ($ISEVAL)
	then
	scr/eval.sh $VOCAB_FILE $GV_VEC_FILE 
fi

