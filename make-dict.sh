#!/bin/bash

INPUT=$1

# input is a file of the entire bible, cleaned by the clean.sh script
# this script outputs the dict.txt file format needed by MFA

paste <( cat $INPUT|tr ' ' '\n'|sort|uniq ) <( cat $INPUT|tr ' ' '\n'|sort|uniq |sed 's/./& /g')
