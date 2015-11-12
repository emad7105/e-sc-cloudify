#!/bin/bash

set -e
blueprint=$1
file=$(ctx node properties source)
CONTAINER_ID=$2
sourcefile=${HOME}/input/${file}
#$(ctx node properties Source)

# Start Timestamp
STARTTIME=`date +%s.%N`

sudo docker exec -it ${CONTAINER_ID} [ ! -d ${blueprint} ] && sudo docker exec -it ${CONTAINER_ID} mkdir ${blueprint}


ctx logger info "copy the input"

filename=$(basename "$sourcefile")
#tar -cf -  ${filename} | docker exec -i ${CONTAINER_ID} /bin/tar -C root/${blueprint} -xf –
cat ${sourcefile} | sudo docker exec -i ${CONTAINER_ID} sh -c 'cat > /root/'${blueprint}/${filename}

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "download $block in $CONTAINER_ID: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv
