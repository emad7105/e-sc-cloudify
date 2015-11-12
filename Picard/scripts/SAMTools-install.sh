#!/bin/bash

set -e
CONTAINER_ID=$1
Lib_URL=$(ctx node properties lib_URL)
Lib_Path=$(ctx node properties lib_path)
Lib_name=$(ctx node properties lib_name)

# Start Timestamp
STARTTIME=`date +%s.%N`

set +e
  Wget=$(sudo docker exec -it ${CONTAINER_ID} which wget)
set -e

	if [[ -z ${Wget} ]]; then
         	sudo docker exec -it ${CONTAINER_ID} apt-get update
  	        sudo docker exec -it ${CONTAINER_ID} apt-get -y install wget
        fi

sudo docker exec -it ${CONTAINER_ID} [ ! -d ${Lib_Path} ] && sudo docker exec -it ${CONTAINER_ID} mkdir ${Lib_Path}

sudo docker exec -it ${CONTAINER_ID} wget -O ${Lib_Path}/${Lib_name} ${Lib_URL}

sudo docker exec -it ${CONTAINER_ID} chmod -R 777 ${Lib_Path}/${Lib_name}

# End timestamp
ENDTIME=`date +%s.%N`

# Convert nanoseconds to milliseconds
# crudely by taking first 3 decimal places
TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}'`
echo "install SAMtools lib : $TIMEDIFF" * | sed 's/[ \t]/, /g' >> ~/list.csv #>~/time.txt 2>&1
