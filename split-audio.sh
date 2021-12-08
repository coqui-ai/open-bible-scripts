CHAPTER=$1

cd $CHAPTER
num=0;
while read line; do
    START=$( echo $line|rev |cut -d' ' -f1|rev|cut -d',' -f1);
    DUR=$( echo $( echo $line|rev |cut -d' ' -f1|rev|cut -d',' -f2) - $START|bc );
    sox ${CHAPTER}.wav JOS_001_$num.wav trim $START $DUR; echo $line > ${CHAPTER}_$num.txt;
    ((num++));
done<joined.tsv 
cd -
