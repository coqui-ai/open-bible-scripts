CHAPTER=$1

join -t'	' -j3 \
     <( sort -t '	' -k3 org/*${CHAPTER}*clean*) \
     <( sort -t '	' -k3 all/$CHAPTER/*best*) \
     > all/$CHAPTER/joined.tsv
