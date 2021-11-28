TXT_VERSES=$1
TEXTGRID=$2

cat $TEXTGRID |tr '\n' ' ' |grep -o "words.*phones"|tr -s ' '| sed 's/\"\"/SPACE/g' | tr -d '"' > /tmp/foo

while read VERSE; do
    REGEX="""intervals \[[0-9]+\]: xmin = [0-9]+\.*[0-9]* xmax = [0-9]+\.*[0-9]* text = SPACE intervals \[[0-9]+\]: xmin = [0-9]+\.*[0-9]* xmax = [0-9]+\.*[0-9]* text = $(echo $VERSE|sed 's/ / \.\*\? /g') intervals \[[0-9]+\]: xmin = [0-9]+\.*[0-9]* xmax = [0-9]+\.*[0-9]* text = SPACE""";
    FOUND="$(grep -P -o "$REGEX" /tmp/foo )"
    VERSE_WORDS=$(echo $VERSE|wc -w)
    FOUND_LEN=$(echo $FOUND|grep -o " text = "|wc -l)
    FOUND_SPACES=$(echo $FOUND|grep -o SPACE|wc -l)
    FOUND_WORDS=$(echo $FOUND_LEN - $FOUND_SPACES | bc)
    if [ $FOUND_WORDS -eq $VERSE_WORDS ]; then
	echo "$( echo $FOUND| grep -o -P "intervals .*? SPACE"|head -n1|cut -d' ' -f5 ) $(echo $FOUND|rev| grep -o -P "ECAPS .*? slavretni"|head -n1|rev| cut -d' ' -f8) $VERSE"
    fi
done<$TXT_VERSES
