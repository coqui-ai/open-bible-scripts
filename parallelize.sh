#!/bin/bash

# must run clean.sh first
# should be run from within directory where biblica data is downloaded and already unzipped

mkdir data

parallelize-text() {
    i=$( echo $1 | sed -E 's/^0+//g');
    AUTHOR=$(echo $i | cut -d'_' -f3);
    PART=$(echo $i | cut -d'_' -f4);
    mkdir -p data/${AUTHOR}_${PART};
    cat $i | cut -f3 > data/${AUTHOR}_${PART}/${AUTHOR}_${PART}.txt;
}

parallelize-audio() {
    i=$( echo $1 | sed -E 's/^0+//g');
    AUTHOR=$(echo $i | cut -d'/' -f2 | cut -d'_' -f1);
    PART=$(echo $i | cut -d'/' -f2 | cut -d'_' -f2 | sed 's/.wav//g');
    mv $i data/${AUTHOR}_${PART}/${AUTHOR}_${PART}.wav;
}

export -f parallelize-text
export -f parallelize-audio

parallel --eta parallelize-text ::: *.clean
parallel --eta parallelize-audio ::: */*.wav

echo "I: Done setting up parallelization for MFA"
