#!/bin/bash

set -e

CONTAINER_ID=$1
LIBRARY_NAME=$(ctx node properties lib_name)

ctx logger info "Installing java on"

# Start Timestamp
STARTTIME=`date +%s.%N`

set +e
  java=$(sudo docker exec -it ${CONTAINER_ID} which java)
set -e

if [[ -z ${java} ]]; then      
        
sudo docker exec -it ${CONTAINER_ID} apt-get update
sudo docker exec -it ${CONTAINER_ID} apt-get -y install ${LIBRARY_NAME}

else
  ctx logger info "Java already has been installed"
fi

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "install java in $CONTAINER_ID: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv
