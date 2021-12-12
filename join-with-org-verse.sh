#!/bin/bash

BEST_VERSES=$1
CHAPTER=$(echo $BEST_VERSES | cut -d'/' -f3)

join -t'	' -j3 \
     <( sort -t '	' -k3 *${CHAPTER}*.clean) \
     <( sort -t '	' -k3 $BEST_VERSES) \
     > data/mfa-output/$CHAPTER/joined.tsv
