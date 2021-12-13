#!/bin/bash

LANGUAGE_NAME=$1
LANGUAGE_ISO=$2

mkdir $LANGUAGE_NAME
cd $LANGUAGE_NAME
parallel --eta -a ../data/$LANGUAGE_NAME.txt "wget {}"

parallel --eta "unzip {}" ::: *.zip

parallel --eta "../clean.sh {} $LANGUAGE_ISO > {= s/_0+/_/g =}.clean" ::: *_read.txt 

wc -l *.clean | grep " 0 " | grep -v URL | rev | cut -d' ' -f1 | rev > CLEANING_ERRORS
echo "I: Could not clean $(wc -l CLEANING_ERRORS) texts"
echo "I: You can find the exact files listed in CLEANING_ERRORS"

parallel --eta -a CLEANING_ERRORS "rm {}"

../parallelize.sh

cat */*/*.txt > /tmp/ALL_CLEAN_TEXT

../make-dict.sh /tmp/ALL_CLEAN_TEXT > dict.txt

echo "I: Done formatting data for the $LANGAUGE_NAME language, now use MFA to align"
echo "I:"
echo 'I:  $ docker run -it --mount "type=bind,src=/home/ubuntu/open-bible-scripts,dst=/mnt" mmcauliffe/montreal-forced-aligner'
echo "I: (base) root@d8095c794d5f:/# conda activate aligner"
echo "I: (aligner) root@d8095c794d5f:/# mfa train -j `nproc` --clean --config_path /mnt/MFA_CONFIG /mnt/${LANGUAGE_NAME}/data /mnt/${LANGUAGE_NAME}/dict.txt /mnt/${LANGUAGE_NAME}/data/mfa-output"
