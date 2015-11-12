#!/bin/bash

set -e

CONTAINER_NAME=$1
Lib_URL=$2
#LIBRARY_NAME=$(ctx node properties lib_name)

#ctx logger info "Installing MegaCC lib on ${CONTAINER_NAME}"
# Start Timestamp
STARTTIME=`date +%s.%N`

        set +e
	  git=$(sudo docker exec -it ${CONTAINER_NAME} which git)
        set -e
	if [[ -z ${git} ]]; then
         	sudo docker exec -it ${CONTAINER_NAME} apt-get update
  	        sudo docker exec -it ${CONTAINER_NAME} apt-get -y install git
        fi

sudo docker exec -it ${CONTAINER_NAME} [ ! -d "work" ] &&sudo docker exec -it ${CONTAINER_NAME} git clone ${Lib_URL}
# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "install the Mega-CC lib: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv
