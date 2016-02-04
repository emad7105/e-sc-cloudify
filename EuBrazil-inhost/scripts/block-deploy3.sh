#!/bin/bash

set -e
blueprint=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_NAME=$(ctx node properties block_name)
BLOCK_URL=$3
Input_file=$4

# Start Timestamp
STARTTIME=`date +%s.%N`

ctx logger info "Deploying ${block} on ${CONTAINER_ID}"
#-----------------------------------------#
#----------- download the task -----------#
if [[ ! -f ~/${blueprint}/tasks/${BLOCK_NAME} ]]; then
    ctx logger info "download ${block} block"
    wget -O ~/${blueprint}/tasks/${BLOCK_NAME} ${BLOCK_URL}
else 
    ctx logger info "task already exists"
fi
#----------- download the task -----------#
#-----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "download $block in $CONTAINER_ID: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv

# Start Timestamp
STARTTIME=`date +%s.%N`

#-----------------------------------------#
#----------- Execute the task ------------#
ctx logger info "Execute the block"
sudo docker exec -it ${CONTAINER_ID} chmod 777 /root/${blueprint}/tasks/${BLOCK_NAME}
sudo docker exec -it ${CONTAINER_ID} java -jar /root/${blueprint}/tasks/${BLOCK_NAME} ${blueprint} ${block} ${Input_file}
#------------ Execute the task -----------#
#-----------------------------------------#

sudo docker ps -s >> ~/docker.csv
# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "execute $block in $CONTAINER_ID: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv
