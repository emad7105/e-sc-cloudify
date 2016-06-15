#!/bin/bash

set -e
blueprint=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_NAME=$(ctx node properties block_name)
BLOCK_URL=$3
LIB_DIR=$4

# Start Timestamp
STARTTIME=`date +%s.%N`

#-----------------------------------------#
#----------- download the task -----------#
ctx logger info " downloading ${BLOCK_NAME}"

[ ! -f ~/.TDWF/${BLOCK_NAME} ] && wget -O ~/.TDWF/${BLOCK_NAME}  ${BLOCK_URL}
sudo docker exec -it ${CONTAINER_ID} [ ! -d tasks ] && sudo docker exec -it ${CONTAINER_ID} mkdir tasks
cat ~/.TDWF/${BLOCK_NAME} | sudo docker exec -i ${CONTAINER_ID} sh -c 'cat > tasks/'${BLOCK_NAME}

#----------- download the task -----------#
#-----------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Downloading ${BLOCK_NAME} task : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv

#--------------------------------------------------------------------------------------------------------#
#------------------------------------------ creating Image ----------------------------------------------#

# Start Timestamp
STARTTIME=`date +%s.%N`

image=$(echo ${BLOCK_NAME} | cut -f 1 -d '.')
ctx logger info "${image}"
if [[ "$(docker images -q dtdwd/${image} 2> /dev/null)" == "" ]]; then
   sudo docker commit -m "new ${image} image" -a "rawa" ${CONTAINER_ID} dtdwd/${image}
fi

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Creating ${image} image : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv

#------------------------------------------ creating Image ----------------------------------------------#
#--------------------------------------------------------------------------------------------------------#
# Start Timestamp
STARTTIME=`date +%s.%N`

ctx logger info "Execute the block"
#--------------------------------------------------------------------------------------------------------#
#-------------------------------------- Execute the task ------------------------------------------------#
if [[ $block = "Mega-NJ" ]]; then
   sudo docker exec -it ${CONTAINER_ID} jar xf tasks/${BLOCK_NAME} M6CC.mao
fi

sudo docker exec -it ${CONTAINER_ID} java -jar tasks/${BLOCK_NAME} ${blueprint} ${block} ${LIB_DIR}
#-------------------------------------- Execute the task ------------------------------------------------#
#--------------------------------------------------------------------------------------------------------#

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "Executing ${BLOCK_NAME} task : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv

#caching the created image
exec ./scripts/caching-policy.sh ${image} ${CONTAINER_ID} &
exec ./scripts/caching-public.sh ${image} &
