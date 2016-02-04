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
if [ ! -f ~/${blueprint}/tasks/${BLOCK_NAME} ]; then
    ctx logger info "download ${BLOCK_NAME} task"
    wget -O ~/${blueprint}/tasks/${BLOCK_NAME} ${BLOCK_URL}
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


ctx logger info "Execute the block"
#-----------------------------------------#
#----------- Execute the task ------------#
if [ $block = "Mega-NJ" ]; then
   sudo docker exec -it ${CONTAINER_ID} jar xf /root/${blueprint}/tasks/${BLOCK_NAME} M6CC.mao
fi

sudo docker exec -it ${CONTAINER_ID} java -jar /root/${blueprint}/tasks/${BLOCK_NAME} ${blueprint} ${block} ${LIB_DIR}
#------------ Execute the task -----------#
#-----------------------------------------#
# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "execute $block in $CONTAINER_ID: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv
