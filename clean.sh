#!/bin/bash

INFILE=$1
LANGUAGE_ISO=$2

# INFILE == a text file from Biblica with "readaloud" in the name

# the punctuation removal was a manual process, not sure if there's a better way
# I got the list of punctuation by looking at all chars in the texts with:
# cat *.txt | grep -o . |sort|uniq -c|sort -n

# covo takes care of some punctuation, but not all, and we need all verses to be
# processed through covo. If covo can't process some text, then it returns None,
# which means issues for our alignments down stream

# also removing numbers is not ideal at all. they should be replaced with words


FILENAME=$(echo $INFILE|rev |cut -d'/' -f1|rev)

cat $INFILE | \
    sed -E 's/[0-9]+\./ /g' | \
    awk '$1=$1' > /tmp/$FILENAME.org

cat $INFILE | dos2unix | \
       sed 's/[\-\:\-\—\!﻿\;\‘\’\(\)\?\-\”\“\,\.]/ /g' | \
       tr '[0-9]' ' ' | \
       tr -s ' ' | \
       awk '$1=$1' | \
       covo validate $LANGUAGE_ISO > /tmp/$FILENAME.clean

if [[ "$(wc -l < /tmp/$FILENAME.org)" -eq "$(wc -l < /tmp/$FILENAME.clean)" ]]; then
    paste <(cat /tmp/$FILENAME.org) <(cat /tmp/$FILENAME.clean) | sed "s/^/$FILENAME	/g"
else
    >&2 echo "ERROR: $INFILE"
fi
