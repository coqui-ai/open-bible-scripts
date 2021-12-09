#!/bin/bash

LANGUAGE_NAME=$1
LANGUAGE_ISO=$2

mkdir $LANGUAGE_NAME
cd $LANGUAGE_NAME
parallel --eta -a ../data/$LANGUAGE_NAME.txt "wget {}"

parallel --eta "unzip {}" ::: *.zip

parallel --eta "../clean.sh {} $LANGUAGE_ISO > {}.clean" ::: *.txt

wc -l *.clean | grep " 0 " | grep -v URL | rev | cut -d' ' -f1 | rev > CLEANING_ERRORS
echo "I: Could not clean $(wc -l CLEANING_ERRORS) texts"
echo "I: You can find the exact files listed in CLEANING_ERRORS"

parallel --eta -a CLEANING_ERRORS "rm {}"

../parallelize.sh

cat */*/*.txt > /tmp/ALL_CLEAN_TEXT

../make-dict.sh /tmp/ALL_CLEAN_TEXT > dict.txt

echo "I: Done formatting data for the $LANGAUGE_NAME language, now use MFA to align"
