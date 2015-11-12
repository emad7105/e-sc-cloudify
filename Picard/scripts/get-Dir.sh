#!/bin/bash

set -e
blueprint=$1
Dir=$(ctx node properties SourceFolder)

# Start Timestamp
STARTTIME=`date +%s.%N` 

sourceDir=${HOME}/${blueprint}/$(basename "$Dir")

input=${HOME}/${Dir}

ctx logger info "copy the Dir"


cp -r ${input} ${sourceDir}

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "get input Dir : $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv #>~/time.txt 2>&1
