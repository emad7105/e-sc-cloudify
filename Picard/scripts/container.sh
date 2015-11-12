#!/bin/bash

set -e
blueprint=$1
CONTAINER_NAME=$(ctx node properties container_ID)
IMAGE_NAME=$(ctx node properties image_name)

# Start Timestamp
STARTTIME=`date +%s.%N` 

ctx logger info "Creating ${CONTAINER_NAME}"

sudo docker run -P --name ${CONTAINER_NAME} -v ~/${blueprint}:/root/${blueprint} -it -d ${IMAGE_NAME} bin/bash

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "create container $CONTAINER_NAME : $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv #>~/time.txt 2>&1
