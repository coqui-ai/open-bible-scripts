#!/bin/bash

for i in ../*/*.wav;do
    ( DIR=$(echo $i|cut -d'/' -f3|cut -d'.' -f1); mkdir $DIR; cp $i -t $DIR; cp ${i/.wav/}.txt -t $DIR ) &
done
