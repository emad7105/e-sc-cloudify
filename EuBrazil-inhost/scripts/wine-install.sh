#!/bin/bash

set -e

CONTAINER_ID=$1
LIBRARY_NAME=$(ctx node properties lib_name)

# Start Timestamp
STARTTIME=`date +%s.%N`


#-------------------------------------------------#
#------------------- install wine ----------------#
set +e
  wine=$(sudo docker exec -it ${CONTAINER_ID} which wine)
set -e

if [[ -z ${wine} ]]; then      
 sudo docker exec -it ${CONTAINER_ID} dpkg --add-architecture i386       
 sudo docker exec -it ${CONTAINER_ID} apt-get update
 sudo docker exec -it ${CONTAINER_ID} apt-get -y install ${LIBRARY_NAME}

fi
#------------------- install wine ----------------#
#-------------------------------------------------#


# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "installing Wine tool : $TIMEDIFF" | sed 's/[ \t]/, /g' >> ~/list.csv
