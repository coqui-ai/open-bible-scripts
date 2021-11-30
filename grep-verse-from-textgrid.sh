TXT_VERSES=$1
TEXTGRID=$2

BOOK="$( echo $TXT_VERSES| sed 's/.txt//'|rev |cut -d'/' -f1|rev )"
cat $TEXTGRID |tr '\n' ' ' |grep -o "words.*phones"|tr -s ' '| sed 's/\"\"/SPACE/g' | sed -E "s/intervals \[[0-9]+\]: //g" | sed 's/xmin = //g' |sed 's/ xmax = /,/g' |sed 's/ text = /,/g' |tr -d '"' > /tmp/foo

SPACE_REGEX="[0-9]+\.*[0-9]*,[0-9]+\.*[0-9]*,SPACE"
WORD_REGEX="[0-9]+\.*[0-9]*,[0-9]+\.*[0-9]*"

while read VERSE; do
    VERSE_REGEX="($SPACE_REGEX)?"
    for WORD in $VERSE; do
	VERSE_REGEX="$VERSE_REGEX ${WORD_REGEX},${WORD}( $SPACE_REGEX)?"
    done
    FULL_REGEX=$VERSE_REGEX
    FOUND="$(grep -P -o "$FULL_REGEX" /tmp/foo )"
    if [[ ! -z $FOUND ]]; then
	FIRST=$(echo $FOUND|cut -d',' -f3|cut -d' ' -f1)
	LAST=$(echo $FOUND|rev|cut -d',' -f1|rev)
	echo $FIRST $LAST
	if [[ $FIRST == "SPACE" ]] && [[ $LAST == "SPACE" ]];then
	    START=$(echo $FOUND|cut -d',' -f1)
	    END=$(echo $FOUND|rev|cut -d',' -f2|rev)
	    echo "$BOOK	$START,$END	$VERSE"
	fi
    fi
done<$TXT_VERSES
