#!/bin/bash

set -e
create_image=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_NAME=$(ctx node properties block_name)
BLOCK_URL=$3

 ###### get task ID ######
   
   source $PWD/Core-LifecycleScripts/get-task-ID.sh
   var=$(func $BLOCK_URL)
   task=${var,,}


ctx logger info "Dowload ${task} on ${CONTAINER_ID}"
# Start Timestamp
STARTTIME=`date +%s.%N`

#-----------------------------------------#
#----------- download the task -----------#


set +e
  wget=$(sudo docker exec -it ${CONTAINER_ID} which wget)
set -e

if [[ -z $wget ]]; then
   sudo docker exec -it ${CONTAINER_ID} apt-get update
   sudo docker exec -it ${CONTAINER_ID} apt-get -y install wget
fi

sudo docker exec -it ${CONTAINER_ID} [ ! -d tasks ] && sudo docker exec -it ${CONTAINER_ID} mkdir tasks
sudo docker exec -it ${CONTAINER_ID} [ ! -f tasks/$task.jar ] && sudo docker exec -it ${CONTAINER_ID} wget -O tasks/$task.jar  ${BLOCK_URL}

#----------- download the task -----------#
#-----------------------------------------#

 # End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "download ${block} to ${CONTAINER_ID}: $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv   
 


