#!/bin/bash

# must run clean.sh first
# should be run from within directory where biblica data is downloaded and already unzipped

cut-clean() {
    i="$1"
    AUTHOR=$(echo $i | cut -d'_' -f3)
    PART=$(echo $i | cut -d'_' -f4)
    if [[ "${#PART}" -eq 2 ]]; then
	PART="0$PART"
    fi
    cat $i | cut -f3 > $AUTHOR/${AUTHOR}_${PART}.txt
}

export -f cut-clean

parallel --eta cut-clean ::: *.clean

mkdir data
cd data

process-for-mfa() {
    i="$1"
    DIR=$(echo $i|cut -d'/' -f3|cut -d'.' -f1);
    mkdir $DIR;
    mv $i -t $DIR
    mv ${i/.txt/}.wav -t $DIR
}

export -f process-for-mfa

parallel --eta process-for-mfa ::: ../*/*.txt

echo "I: Done setting up parallelization for MFA"
#for i in ../*/*.txt; do
#    ( DIR=$(echo $i|cut -d'/' -f3|cut -d'.' -f1); mkdir $DIR; cp $i -t $DIR; cp ${i/.txt/}.wav -t $DIR ) &
#done
