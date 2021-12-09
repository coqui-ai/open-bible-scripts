#!/bin/bash

# must run clean.sh first
# should be run from within directory where biblica data is downloaded and already unzipped


mkdir data
cd data

for i in ../*/*.txt; do
    ( DIR=$(echo $i|cut -d'/' -f3|cut -d'.' -f1); mkdir $DIR; cp $i -t $DIR; cp ${i/.txt/}.wav -t $DIR ) &
done
wait

echo "I: Done setting up parallelization for MFA"
