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
ctx logger info "download ${block} block"

[ ! -f ~/.TDWF/${BLOCK_NAME} ] && wget -O ~/.TDWF/${BLOCK_NAME}  ${BLOCK_URL}

sudo docker exec -it ${CONTAINER_ID} [ ! -d tasks ] && sudo docker exec -it ${CONTAINER_ID} mkdir tasks

cat ~/.TDWF/${BLOCK_NAME} | sudo docker exec -i ${CONTAINER_ID} sh -c 'cat > tasks/'${BLOCK_NAME}

#----------- download the task -----------#
#-----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "downloading ${BLOCK_NAME} task : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv

#-----------------------------------------------------------------------------------------------------#
#----------------------------------- Creating the task image -----------------------------------------#

# Start Timestamp
STARTTIME=`date +%s.%N`

image=$(echo ${BLOCK_NAME} | cut -f 1 -d '.')
ctx logger info "${image}"
if [[ "$(docker images -q ${image} 2> /dev/null)" = "" ]]; then
   sudo docker commit -m "new ${image} image" -a "rawa" ${CONTAINER_ID} dtdwd/${image}
fi

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Creating ${Image} image : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv

#----------------------------------- Creating the task image -----------------------------------------#
#------------------------------------------------------------------------------------------------------#
# Start Timestamp
STARTTIME=`date +%s.%N`

#-----------------------------------------#
#----------- Execute the task ------------#

ctx logger info "Execute the block"
#sudo docker exec -it ${CONTAINER_ID} chmod 777 /root/${blueprint}/tasks/${BLOCK_NAME}
sudo docker exec -it ${CONTAINER_ID} java -jar tasks/${BLOCK_NAME} ${blueprint} ${block} ${Input_file}

#------------ Execute the task -----------#
#-----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Execting ${BLOCK_NAME} task : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv
