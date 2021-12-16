#!/bin/bash

LANGUAGE_NAME=$1
#mkdir $LANGUAGE_NAME
cd $LANGUAGE_NAME

#parallel --eta -a ../data/$LANGUAGE_NAME.txt "wget {}"

for i in *_wav.zip;do
    DIR=$(echo $i|cut -d'_' -f2);
#    mkdir $DIR
#    unzip $i -d $DIR
    python ../split_verse.py --path_to_wavs "$DIR/" --path_to_timings "timingfiles/$DIR/" --path_to_book_sfm *"${DIR}"*.SFM --output "$DIR/"
done
