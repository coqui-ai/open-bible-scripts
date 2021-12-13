#!/bin/bash

LANGUAGE_NAME=$1
cd $LANGUAGE_NAME

parallel --eta ../grep-verse-from-textgrid.sh ::: data/mfa-output/*/*.TextGrid
echo "I: Done pulling out best verses from $LANGAUGE_NAME language alignment"

parallel --eta ../join-with-org-verse.sh ::: data/mfa-output/*/*_best_verses.tsv
echo "I: Done joining best (cleaned) verses with original verses for $LANGAUGE_NAME language"

parallel --eta ../split-audio.sh ::: data/mfa-output/*/joined.tsv
echo "I: Done splitting verses from audio in $LANGAUGE_NAME language"

parallel --eta "echo {= s/.txt/.wav/ =}\t$( cat {} )" ::: data/mfa-output/*/*.txt
echo "I: Done splitting verses from audio in $LANGAUGE_NAME language"

parallel --eta "paste <(echo {= s/.txt/.wav/g =} ) <( cat {} )" ::: data/mfa-output/*/*.txt > all.tsv
echo "I: Find master TSV file for $LANGUAGE_NAME language in $LANGUAGE_NAME/all.tsv"
