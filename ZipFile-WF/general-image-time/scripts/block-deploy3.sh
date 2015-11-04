#!/bin/bash

set -e
blueprint=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_NAME=$(ctx node properties block_name)
BLOCK_URL=$3

# Start Timestamp
STARTTIME=`date +%s.%N`

sudo docker exec -it ${CONTAINER_ID} [ ! -d ${blueprint} ] && sudo docker exec -it ${CONTAINER_ID} mkdir ${blueprint}

sudo docker exec -it ${CONTAINER_ID} [ ! -f ${blueprint}/${BLOCK_NAME} ] && sudo docker exec -it ${CONTAINER_ID} wget -O ${blueprint}/${BLOCK_NAME} ${BLOCK_URL}
# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Time for download block $block is: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv #>~/time.txt 2>&1

STARTTIME=`date +%s.%N`

ctx logger info "Execute the block"
sudo docker exec -it ${CONTAINER_ID} java -jar ${blueprint}/${BLOCK_NAME} ${blueprint} ${block}
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Time for running block $block is: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv #>~/time.txt 2>&1
