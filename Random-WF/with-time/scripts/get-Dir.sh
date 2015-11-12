#!/bin/bash

set -e
blueprint=$1
Dir=~/myDir #$(ctx node properties SourceFolder)
# Start Timestamp
STARTTIME=`date +%s.%N`
sourceDir=${HOME}/${blueprint}/$(basename "$Dir")


#ctx logger info "copy the Dir"


cp -r ${Dir} ${sourceDir}
# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "creating the container $CONTAINER_NAME: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv 
