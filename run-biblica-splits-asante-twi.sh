#!/bin/bash

LANGUAGE_NAME="asante-twi"
mkdir $LANGUAGE_NAME
cd $LANGUAGE_NAME

#parallel --eta -a ../data/$LANGUAGE_NAME.txt "wget {}"

#unzip twiONA20_SFM.zip
#unzip twiONA20_timingfiles.zip

for i in *_wav.zip;do
    DIR=$(echo $i|cut -d'_' -f2);
#    mkdir -p $DIR
#    unzip $i -d $DIR
    python ../split_verse_asante-twi.py --path_to_wavs "$DIR/$DIR/" --path_to_timings "timingfiles/$DIR/" --path_to_book_sfm twiONA20_SFM/*"${DIR}"*.SFM --output "$DIR/"
done
