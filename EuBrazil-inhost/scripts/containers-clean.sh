#!/bin/bash

set -e
container1=$1

container2=$2
	
#ctx logger info "Deleting ${container}"
# Start Timestamp
STARTTIME=`date +%s.%N`

a=${@}

for var in "$@"
do
  sudo docker commit -m "new ${var} image" -a "rawa" ${var} myimage/${var}
  sudo docker rm -f "${var}"
done

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "destroy the containers : $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv

