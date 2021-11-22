INPUT=$1

paste <( cat $INPUT|tr ' ' '\n'|sort|uniq ) <( cat $INPUT|tr ' ' '\n'|sort|uniq |sed 's/./& /g')
