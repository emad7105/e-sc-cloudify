#!/bin/bash

set -e

CONTAINER_NAME=$1
Lib_URL=$2
#LIBRARY_NAME=$(ctx node properties lib_name)

#ctx logger info "Installing ClustalW lib on ${CONTAINER_NAME}"
# Start Timestamp
STARTTIME=`date +%s.%N`

        set +e
	  Wget=$(sudo docker exec -it ${CONTAINER_NAME} which wget)
        set -e
	if [[ -z ${Wget} ]]; then
         	sudo docker exec -it ${CONTAINER_NAME} apt-get update
  	        sudo docker exec -it ${CONTAINER_NAME} apt-get -y install wget
        fi
if [[ ! -d "work" ]]; then
    sudo docker exec -it ${CONTAINER_NAME} wget ${Lib_URL}
    sudo docker exec -it ${CONTAINER_NAME} tar -zxvf clustalw-2.1-linux-x86_64-libcppstatic.tar.gz
fi

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "install the Clustal lib: $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv
