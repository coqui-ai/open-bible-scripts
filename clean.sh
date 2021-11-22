INFILE=$1
cat $INFILE| sed 's/[\-\:\-\—\!﻿\;\‘\’\(\)\?\-\”\“\,\.]/ /g'|tr '[0-9]' ' '|tr -s ' '| awk '$1=$1'|covo validate yo
