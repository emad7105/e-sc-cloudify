#!/bin/bash

set -e

CONTAINER_NAME=$1
Lib_URL=$(ctx node properties lib_URL)
blueprint=$3
LIBRARY_NAME=$(ctx node properties lib_name)
echo "Installing ClustalW-library on ${CONTAINER_ID}" >> ~/depl-steps.txt

ctx logger info "Installing ClustalW lib on ${CONTAINER_NAME}"
# Start Timestamp
STARTTIME=`date +%s.%N`

 
if [[ ! -f ~/${blueprint}/${LIBRARY_NAME}.tar.gz ]]; then
    wget -O ~/${blueprint}/${LIBRARY_NAME}.tar.gz ${Lib_URL}
    sudo docker exec -it ${CONTAINER_NAME} tar -zxvf /root/${blueprint}/${LIBRARY_NAME}.tar.gz
fi

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "install the Clustal lib: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv
