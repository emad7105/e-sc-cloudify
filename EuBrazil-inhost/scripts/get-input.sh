#!/bin/bash

set -e
blueprint=$1
file=$(ctx node properties Source)
CONTAINER_ID=$2
input_dir=$3
inputFile=$4

# Start Timestamp
STARTTIME=`date +%s.%N`
size="$(du -ch ${input_dir}/${inputFile} | grep total)"
echo "copy the input file ${input_dir}/${inputFile}:${size} to ${CONTAINER_ID}:root/${blueprint}/${file}" >> ~/depl-steps.txt


ctx logger info "copy the input ${input_dir}/${inputFile}"
cp ${input_dir}/${inputFile} ~/${blueprint}/${inputFile}

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "get input to $CONTAINER_ID: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv 
