set -e
blueprint=$1
block=$(ctx node name)
CONTAINER_ID=$2
BLOCK_NAME=$(ctx node properties block_name)
BLOCK_URL=$3
LIB_DIR=$4

# Start Timestamp
STARTTIME=`date +%s.%N`

sudo docker exec -it ${CONTAINER_ID} [ ! -d ${blueprint} ] && sudo docker exec -it ${CONTAINER_ID} mkdir ${blueprint}

sudo docker exec -it ${CONTAINER_ID} [ ! -f ${blueprint}/${BLOCK_NAME} ] && sudo docker exec -it ${CONTAINER_ID} wget -O ${blueprint}/${BLOCK_NAME} ${BLOCK_URL}

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "download $block in $CONTAINER_ID: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv

# Start Timestamp
STARTTIME=`date +%s.%N`
ctx logger info "Execute the block"
if [ $block = "Mega-NJ" ]; then
   sudo docker exec -it ${CONTAINER_ID} jar xf ${blueprint}/${BLOCK_NAME} M6CC.mao
fi
sudo docker exec -it ${CONTAINER_ID} java -jar ${blueprint}/${BLOCK_NAME} ${blueprint} ${block} ${LIB_DIR}

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "execute $block in $CONTAINER_ID: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv
