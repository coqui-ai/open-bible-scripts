#!/bin/bash

JOINED_TSV=$1
CHAPTER_DIR=$(echo $JOINED_TSV|rev |cut -d'/' -f2-|rev)
CHAPTER_NAME=$(echo $JOINED_TSV|rev |cut -d'/' -f2|rev)
CHAPTER_WAV=$(echo $CHAPTER_DIR|sed 's/mfa-output\///')/$CHAPTER_NAME.wav

num=0;
while read line; do
    START=$( echo $line|rev |cut -d' ' -f1|rev|cut -d',' -f1);
    DUR=$( echo $( echo $line|rev |cut -d' ' -f1|rev|cut -d',' -f2) - $START|bc );
    sox $CHAPTER_WAV $CHAPTER_DIR/${CHAPTER_NAME}_$num.wav trim $START $DUR;
    echo "$line" | cut -f3 > $CHAPTER_DIR/${CHAPTER_NAME}_$num.txt;
    num=$((num+1));
done<$JOINED_TSV
