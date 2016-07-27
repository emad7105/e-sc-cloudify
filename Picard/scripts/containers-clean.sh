#!/bin/bash

set -e
container1=$1

container2=$2
	
# Start Timestamp
STARTTIME=`date +%s.%N`

#--------------------------------------------------------------#
#------------------  container destroying ---------------------#
a=${@}

for var in "$@"
do
  sudo docker rm -f "${var}"
done
#------------------  container destroying ----------#
#--------------------------------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Destroying some containers : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv
