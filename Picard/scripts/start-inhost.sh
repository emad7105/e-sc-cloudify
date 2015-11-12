#!/bin/bash

set -e

blueprint=$1
# Start Timestamp
STARTTIME=`date +%s.%N` 

if [ ! -d ~/${blueprint} ]; then

   mkdir ~/${blueprint}

fi

ctx logger info "copy ${blueprint}.yaml to ~/${blueprint}"

cp ${blueprint}.yaml ~/${blueprint}

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "initiate WF folder : $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv #>~/time.txt 2>&1
