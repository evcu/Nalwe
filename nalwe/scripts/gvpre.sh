COOCCURRENCE_FILE=CoOcr/gv.CoOc
MEMORY=32.0

    $GV_DIR/cooccur -memory $MEMORY -vocab-file $VOCAB_FILE -verbose $VERBOSE \
    -window-size $WINDOW_SIZE < $CORPUS > $COOCCURRENCE_FILE
    if [[ $? -eq 0 ]]
    then
    echo $WINDOW_SIZE
      $GV_DIR/shuffle -memory $MEMORY -verbose $VERBOSE < $COOCCURRENCE_FILE > $COOCCURRENCE_SHUF_FILE
      rm $COOCCURRENCE_FILE
    fi
